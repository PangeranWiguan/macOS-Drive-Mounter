#!/bin/bash
# ==============================================================================
#  macOS-Drive-Mounter - Main Mounting Script (v6 - Final w/ Notifications)
#  Copyright (c) 2025 Pangeran Wiguan (pangeranwiguan@gmail.com)
#  Licensed under the MIT License. See LICENSE file for details.
#  Project URL: https://pangeranwiguan.com/macos-drive-mounter
# ==============================================================================

# --- Configuration ---
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DRIVES_FILE="${SCRIPT_DIR}/drives.txt"
LOCK_FILE="/tmp/macos_drive_mounter.lock"
STATE_DIR="${HOME}/.local/state/macos_drive_mounter"
NOTIFICATION_COOLDOWN_FILE="${STATE_DIR}/notification_sent"
NOTIFICATION_COOLDOWN_SECONDS=300 # Notify at most once every 5 minutes.

# Ensure the state directory exists.
mkdir -p "${STATE_DIR}"

# --- Concurrency Lock ---
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi
touch "$LOCK_FILE"
trap 'rm -f "$LOCK_FILE"' EXIT

# --- Main Logic ---
failed_mounts=() # Array to track drives that fail during this run.

# Read the drives file line by line, ignoring comments and blank lines.
grep -v '^\s*#' < "$DRIVES_FILE" | grep -v '^\s*$' | while read -r line; do
    eval "set -- $line"
    server=$1
    share=$2
    user=$3
    pass=$4
    
    mount_point="/Volumes/${share}"

    # Robust check: Verify if a drive is ACTIVELY mounted at the location.
    if mount | grep -q " on ${mount_point} "; then
        continue
    else
        # Attempt to mount using AppleScript.
        osascript <<EOD
            try
                tell application "Finder"
                    mount volume "smb://${server}/${share}" as user name "${user}" with password "${pass}"
                end tell
            end try
EOD
        
        # Give the mount a moment to complete before checking its status.
        sleep 2 

        # Verify if the mount succeeded. If not, add to the failure list.
        if ! mount | grep -q " on ${mount_point} "; then
            failed_mounts+=("${share} on ${server}")
        fi
    fi
done

# --- Notification Logic ---
# Send a notification only if there were failures.
if [ ${#failed_mounts[@]} -gt 0 ]; then
    # Intelligent notifications: Only notify if it's a new failure or the cooldown has passed.
    if ! [ -f "$NOTIFICATION_COOLDOWN_FILE" ] || [ $(find "$NOTIFICATION_COOLDOWN_FILE" -mmin +$(($NOTIFICATION_COOLDOWN_SECONDS/60)) | wc -l) -gt 0 ]; then
        
        # Format the list of failed shares for the notification.
        failed_shares_list=$(printf ", %s" "${failed_mounts[@]}")
        failed_shares_list=${failed_shares_list:2} # Remove leading comma and space.
        
        osascript -e "display notification \"The script will keep retrying in the background.\" with title \"Drive Mounter Failed\" subtitle \"Could not connect to: ${failed_shares_list}\""
        
        # Touch the cooldown file to update its timestamp, resetting the timer.
        touch "$NOTIFICATION_COOLDOWN_FILE"
    fi
else
    # If there were no failures on this run, reset the notification cooldown.
    rm -f "$NOTIFICATION_COOLDOWN_FILE"
fi

exit 0