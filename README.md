# 💾 macOS Drive Mounter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A simple, robust, and persistent tool to automatically mount your network drives on macOS and keep them connected.

This script solves the common frustration of macOS dropping connections to network shares after waking from sleep or changing networks. It uses the same reliable mounting engine as Finder's "Go > Connect to Server" feature, ensuring the highest level of compatibility.

**Visit the project's homepage:** [pangeranwiguan.com/macos-drive-mounter](https://pangeranwiguan.com/macos-drive-mounter)

---

## ✨ Features

- ⚙️ **Reliable Mounting Engine:** Uses AppleScript to communicate directly with the Finder, bypassing the inconsistencies of lower-level mount commands.
- 🚀 **Runs Automatically:** A persistent agent runs at login and every 30 seconds to ensure your drives are always available.
- 📝 **Simple Configuration:** A clean, 4-column text file makes adding or changing drives incredibly easy. No more confusing URL encoding!
- 📦 **Portable & Self-Contained:** Everything you need is in one folder. Place it anywhere on your Mac and run the installer.
- 🛡️ **macOS Security Compliant:** Works with modern macOS security features by guiding you through a one-time permission process.

---

## 📥 Installation

Follow these steps to get the script up and running.

1.  **Get the Files**

    Clone or download this repository to a permanent location on your Mac (e.g., in your `~/Documents` or `~/Scripts` folder).

    ```bash
    # Clone the repository using Git
    git clone https://github.com/your-username/macOS-Drive-Mounter.git
    ```

    _Or, download the ZIP and extract it._

2.  **Navigate to the Directory**

    Open the **Terminal** app and change into the newly created folder.

    ```bash
    cd path/to/macOS-Drive-Mounter
    ```

3.  **Make Scripts Executable**

    You need to give the scripts permission to run.

    ```bash
    chmod +x *.sh
    ```

4.  **Run the Installer**

    The installer will set up a system agent to automatically run the script for you.

    ```bash
    ./install.sh
    ```

5.  **⚠️ One-Time Security Prompts**

    The very first time the script runs, macOS will ask for your permission. **This is normal and expected.**

    - You may see a prompt asking for permission to control the Finder. **Click Allow.**
    - For each new server, you may see a prompt asking, "You are attempting to connect to the server...". **Click Connect.**

    Once you have approved these prompts, they will not appear again, even after a reboot.

✅ That's it! The script is now active and will manage your drives silently in the background.

---

## ⚙️ Configuration

All you need to do is tell the script which drives to mount by editing the `drives.txt` file.

1.  Open `drives.txt` in a text editor.
2.  Add your drives using the simple 4-column format below.

```
# ==============================================================================
#  macOS-Drive-Mounter Drive Configuration
# ==============================================================================
#
# INSTRUCTIONS:
#
# 1. Add each drive on a new line using the 4-column format below.
# 2. Use spaces or tabs to separate the four columns.
# 3. If your Share Name or Password contains spaces or special characters
#    (like @, !, $, #), you MUST enclose it in "double quotes".
#
# --- FORMAT ---
#
# server_address    "Share Name"    username    "Password"
#
# --- EXAMPLES (replace these with your actual drives) ---

# Example 1: Simple share on a NAS using its hostname
MyNAS.local             Public          guest       ""

# Example 2: Share with a space in its name, using an IP address
192.168.1.50            "My Documents"  myuser      "SimplePass123"

# Example 3: Share with a special character (@) in its name
fileserver.local        "Scans@HP"      scanner     "Scan-Pass!"

# Example 4: Password with special characters that requires quotes
10.0.0.10               Backups         admin       "My$uperP@ssw0rd!"
```

Changes to `drives.txt` are picked up automatically on the next run.

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
