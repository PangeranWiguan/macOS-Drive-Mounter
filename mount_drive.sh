#!/bin/bash
# ==============================================================================
#  macOS-Drive-Mounter - Main Mounting Script
#  Copyright (c) 2025 Pangeran Wiguan (pangeranwiguan@gmail.com)
#  Licensed under the MIT License. See LICENSE file for details.
#  Project URL: https://pangeranwiguan.com/macos-drive-mounter
# ==============================================================================

# --- Configuration ---
# Find the directory where this script is located. This makes the script portable.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Define paths for configuration and state files.
DRIVES_FILE="${SCRIPT_DIR}/drives.txt"
STATE_DIR="${HOME}/.local/state/macos_drive_mounter"
FAILED_DRIVES_FILE="${STATE_DIR}/failed_drives.txt"
LOCK_FILE="/tmp/macos_drive_mounter.lock"
NOTIFICATION_COOLDOWN_FILE="${STATE_DIR}/notification_sent"
NOTIFICATION_COOLDOWN_SECONDS=300 # Notify at most once every 5 minutes.

# Ensure the state directory exists for storing persistent data.
mkdir -p "${STATE_DIR}"

# --- Concurrency Lock ---
# If the lock file exists, another instance is already running. Exit immediately.
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi
touch "$LOCK_FILE"

# Ensure the lock file is removed when the script exits, for any reason (success, failure, interrupt).
trap 'rm -f "$LOCK_FILE"' EXIT

# --- Main Logic ---

# 1. Determine which drives to process.
drives_to_process=()
if [ -s "$FAILED_DRIVES_FILE" ]; then
    # If the failed drives file exists and is not empty, process only those that previously failed.
    mapfile -t drives_to_process < "$FAILED_DRIVES_FILE"
else
    # Otherwise, this is a clean run. Process the full list from the main config file.
    mapfile -t drives_to_process < "$DRIVES_FILE"
fi

# 2. Process the list of drives.
current_failures=()
for drive_url in "${drives_to_process[@]}"; do
    # Skip empty lines or lines that are comments in the config file.
    if [[ -z "$drive_url" || "$drive_url" == \#* ]]; then
        continue
    fi

    # Derive the mount point name from the last part of the URL.
    # e.g., smb://user@server/ShareName becomes /Volumes/ShareName
    share_name=$(basename "$drive_url")
    mount_point="/Volumes/${share_name}"

    # Check if the drive is already mounted at the target location.
    if mount | grep -q "on ${mount_point}"; then
        continue
    else
        # Not mounted. First, ensure the mount point directory exists.
        mkdir -p "${mount_point}"
        
        # Attempt to mount with a 5-second connection timeout.
        if ! mount -t smbfs -o "timeout=5" "$drive_url" "$mount_point"; then
            # If the mount command fails, add the drive to our list of current failures.
            current_failures+=("$drive_url")
        fi
    fi
done

# 3. Update state and notify the user if necessary.
if [ ${#current_failures[@]} -eq 0 ]; then
    # Success! Everything that needed mounting was mounted. Clean up state files.
    rm -f "$FAILED_DRIVES_FILE"
    rm -f "$NOTIFICATION_COOLDOWN_FILE"
else
    # There are still failures. Save the list of failed drives for the next run.
    printf "%s\n" "${current_failures[@]}" > "$FAILED_DRIVES_FILE"

    # Intelligent notifications: Only notify if it's a new failure or the cooldown has passed.
    if ! [ -f "$NOTIFICATION_COOLDOWN_FILE" ] || [ $(find "$NOTIFICATION_COOLDOWN_FILE" -mmin +$(($NOTIFICATION_COOLDOWN_SECONDS/60)) | wc -l) -gt 0 ]; then
        failed_shares=$(printf ", %s" "${current_failures[@]}")
        failed_shares=${failed_shares:2} # Format for readability.
        
        osascript -e "display notification \"The script will keep retrying in the background.\" with title \"Drive Mounter Failed\" subtitle \"Could not connect to: ${failed_shares}\""
        
        # Touch the cooldown file to update its timestamp, resetting the timer.
        touch "$NOTIFICATION_COOLDOWN_FILE"
    fi
fi

# The 'trap' command will automatically remove the lock file.
exit 0