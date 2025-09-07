#!/bin/bash
# ==============================================================================
#  macOS-Drive-Mounter - Uninstallation Script
#  Copyright (c) 2025 Pangeran Wiguan (pangeranwiguan@gmail.com)
#  Licensed under the MIT License. See LICENSE file for details.
#  Project URL: https://pangeranwiguan.com/macos-drive-mounter
# ==============================================================================

AGENT_LABEL="com.pangeranwiguan.macosdrivemounter"
AGENT_PATH="${HOME}/Library/LaunchAgents/${AGENT_LABEL}.plist"
STATE_DIR="${HOME}/.local/state/macos_drive_mounter"

echo "Stopping and unloading the system agent..."
launchctl unload "${AGENT_PATH}" 2>/dev/null

echo "Removing agent file..."
rm -f "${AGENT_PATH}"

echo "Removing script state files..."
rm -rf "${STATE_DIR}"

echo ""
echo "✅ Uninstallation Complete."
echo "The script will no longer run. You can now safely delete the macOS-Drive-Mounter folder."