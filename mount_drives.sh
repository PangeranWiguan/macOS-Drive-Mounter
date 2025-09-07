#!/bin/bash
# ==============================================================================
#  macOS-Drive-Mounter - Main Mounting Script
#  Copyright (c) 2025 Pangeran Wiguan (pangeranwiguan@gmail.com)
#  Licensed under the MIT License. See LICENSE file for details.
#  Project URL: https://pangeranwiguan.com/macos-drive-mounter
# ==============================================================================

# --- Configuration ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DRIVES_FILE="${SCRIPT_DIR}/drives.txt"
STATE_DIR="${HOME}/.local/state/macos_drive_mounter"
FAILED_DRIVES_FILE="${STATE_DIR}/failed_drives.txt"
LOCK_FILE="/tmp/macos_drive_mounter.lock"
NOTIFICATION_COOLDOWN_FILE="${STATE_DIR}/notification_sent"
NOTIFICATION_COOLDOWN_SECONDS=300

mkdir -p "${STATE_DIR}"

# --- Concurrency Lock ---
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi
touch "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# --- Main Logic ---

# 1. Determine which drives to process.
drives_to_process=()
target_file="$DRIVES_FILE"

if [ -s "$FAILED_DRIVES_FILE" ]; then
    target_file="$FAILED_DRIVES_FILE"
fi

while IFS= read -r line || [[ -n "$line" ]]; do
    drives_to_process+=("$line")
done < "$target_file"

# 2. Process the list of drives.
current_failures=()
for drive_url in "${drives_to_process[@]}"; do
    if [[ -z "$drive_url" || "$drive_url" == \#* ]]; then
        continue
    fi

    # Get the URL-encoded share name from the end of the URL.
    encoded_share_name="${drive_url##*/}"
    
    # **FINAL FIX**: Decode the share name for the local filesystem path.
    # This converts things like '%20' into a real space for the folder name.
    decoded_share_name=$(printf '%b' "${encoded_share_name//%/\\x}")
    mount_point="/Volumes/${decoded_share_name}"

    # Check if the drive is already mounted using the decoded name.
    if mount | grep -q "on ${mount_point}"; then
        continue
    else
        # Attempt to mount. The source URL is still encoded, but the destination is decoded.
        if ! mount -t smbfs -o "timeout=5" "$drive_url" "$mount_point"; then
            current_failures+=("$drive_url")
        fi
    fi
done

# 3. Update state and notify the user if necessary.
if [ ${#current_failures[@]} -eq 0 ]; then
    rm -f "$FAILED_DRIVES_FILE"
    rm -f "$NOTIFICATION_COOLDOWN_FILE"
else
    printf "%s\n" "${current_failures[@]}" > "$FAILED_DRIVES_FILE"
    if ! [ -f "$NOTIFICATION_COOLDOWN_FILE" ] || [ $(find "$NOTIFICATION_COOLDOWN_FILE" -mmin +$(($NOTIFICATION_COOLDOWN_SECONDS/60)) | wc -l) -gt 0 ]; then
        failed_shares=$(printf ", %s" "${current_failures[@]}")
        failed_shares=${failed_shares:2}
        
        osascript -e "display notification \"The script will keep retrying in the background.\" with title \"Drive Mounter Failed\" subtitle \"Could not connect to: ${failed_shares}\""
        
        touch "$NOTIFICATION_COOLDOWN_FILE"
    fi
fi

exit 0