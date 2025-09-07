# 💾 macOS Drive Mounter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A simple, robust, and persistent tool to automatically mount your network drives on macOS and keep them connected.

This script solves the common frustration of macOS dropping connections to network shares (SMB, AFP) after waking from sleep, changing networks, or temporary server disconnections. It works tirelessly in the background to ensure your drives are always available when you need them.

**Visit the project's homepage:** [pangeranwiguan.com/macos-drive-mounter](https://pangeranwiguan.com/macos-drive-mounter)

---

## ✨ Features

- 🚀 **Persistent & Automatic:** Set it up once and forget it. The script automatically runs at login and every 30 seconds to check your drives.
- 🧠 **Intelligent Retries:** If a drive is disconnected, the script will relentlessly try to reconnect. It's smart enough to only focus on _failed_ drives, making it extremely lightweight and efficient.
- 🔔 **Smart Notifications:** You'll be notified if a drive cannot be mounted after a few attempts. Notifications are rate-limited to prevent spam if a server is down for an extended period.
- 📝 **Simple Text-Based Configuration:** Just list the drives you want to mount in a simple text file. No complicated settings.
- 📦 **Portable & Self-Contained:** Everything you need is in one folder. Place it anywhere on your Mac, run the installer, and you're done.

---

## 📥 Installation

Follow these steps to get the script up and running.

1.  **Get the Files**

    Clone or download this repository to a permanent location on your Mac (e.g., `~/Documents` or `~/Scripts`).

    ```bash
    # Clone the repository using Git
    git clone https://github.com/your-username/macOS-Drive-Mounter.git
    ```

    _Or, download the ZIP and extract it._

2.  **Navigate to the Directory**

    Open the Terminal app and change into the newly created folder.

    ```bash
    cd path/to/macOS-Drive-Mounter
    ```

3.  **Make Scripts Executable**

    You need to give the scripts permission to run.

    ```bash
    chmod +x *.sh
    ```

4.  **Run the Installer**

    The installer will create a system agent that automatically runs the script for you.

    ```bash
    ./install.sh
    ```

✅ That's it! The script is now active and will manage your drives.

---

## ⚙️ Configuration

All you need to do is tell the script which drives to mount.

1.  Open the `drives.txt` file in a text editor.
2.  Add your network drives, one per line, using the full URL format.

The script comes with a heavily commented example file to guide you:

```bash
# ==============================================================================
#  macOS-Drive-Mounter Drive Configuration
#  Copyright (c) 2025 Pangeran Wiguan
#  Licensed under the MIT License. See LICENSE file for details.
#  Project URL: https://pangeranwiguan.com/macos-drive-mounter
# ==============================================================================

#
# INSTRUCTIONS:
#
# 1. Add each network drive you want to mount on a new line.
# 2. Use the full SMB URL format: smb://user:password@server/share
#
#    - user:       Your username for the network share.
#    - password:   Your password for the share. Special characters in passwords
#                  may need to be URL-encoded (e.g., '#' becomes %23).
#    - server:     The server's IP address (e.g., 192.168.1.100) or its
#                  hostname (e.g., MyNAS).
#    - share:      The name of the shared folder.
#
# 3. Lines starting with a hash (#) are ignored.
#
# WARNING: This file stores your passwords in plain text. Ensure this file is
# kept in a secure location and has appropriate file permissions.
#
# --- EXAMPLES (replace these with your actual drives) ---

smb://myuser:MyPassword123@192.168.1.100/Documents
smb://pangeran:S3curePa$$w0rd@MyNAS/Media
smb://admin:admin@router-storage/Backups
```

Changes to `drives.txt` are picked up automatically on the next run.

---

## 🔧 Usage

The script is designed to be completely autonomous. Once installed, it runs in the background. Your configured drives will appear in Finder under "Locations" and on your Desktop (if enabled in Finder settings) and will automatically reconnect whenever necessary.

---

## 🗑️ Uninstallation

If you wish to stop the script and remove it:

1.  **Navigate to the Directory**

    Open Terminal and go to the `macOS-Drive-Mounter` folder.

    ```bash
    cd path/to/macOS-Drive-Mounter
    ```

2.  **Run the Uninstaller**

    This will stop the background service and remove all system files created by the installer.

    ```bash
    ./uninstall.sh
    ```

3.  **Delete the Folder**

    You can now safely delete the `macOS-Drive-Mounter` folder.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for the full text.

---

## ✍️ Author

**Pangeran Wiguan**

- **Website:** [pangeranwiguan.com](https://pangeranwiguan.com)
- **Email:** [pangeranwiguan@gmail.com](mailto:pangeranwiguan@gmail.com)
- **Project Page:** [pangeranwiguan.com/macos-drive-mounter](https://pangeranwiguan.com/macos-drive-mounter)
