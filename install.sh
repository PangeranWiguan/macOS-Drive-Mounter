#!/bin/bash
# ==============================================================================
#  macOS-Drive-Mounter - Installation Script
#  Copyright (c) 2025 Pangeran Wiguan (pangeranwiguan@gmail.com)
#  Licensed under the MIT License. See LICENSE file for details.
#  Project URL: https://pangeranwiguan.com/macos-drive-mounter
# ==============================================================================

# --- Configuration ---
# A unique name for the system agent.
AGENT_LABEL="com.pangeranwiguan.macosdrivemounter"
# How often to run the script, in seconds. 30 seconds is a robust default.
RUN_INTERVAL=30

# --- Get Absolute Paths ---
# This makes the solution portable, allowing the folder to be anywhere.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_PATH="${SCRIPT_DIR}/mount_drives.sh"
AGENT_PATH="${HOME}/Library/LaunchAgents/${AGENT_LABEL}.plist"

# --- Create the launchd Agent .plist file ---
echo "Creating system agent at: ${AGENT_PATH}"

cat <<EOF > "${AGENT_PATH}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${AGENT_LABEL}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${SCRIPT_PATH}</string>
    </array>
    <key>StartInterval</key>
    <integer>${RUN_INTERVAL}</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# --- Load and Start the Agent ---
# Unload any existing version first to ensure a clean start.
launchctl unload "${AGENT_PATH}" 2>/dev/null
echo "Loading and starting the agent..."
launchctl load "${AGENT_PATH}"

echo ""
echo "✅ Installation Complete!"
echo "The script is now active and will run every ${RUN_INTERVAL} seconds."
echo "You can place the 'macOS-Drive-Mounter' folder anywhere, but do not move it after installation."
echo "If you move the folder, simply run this installer again from the new location."