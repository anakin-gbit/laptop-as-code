# USB Setup Guide

Follow these steps to create the automated bootable USB for this environment.

### Prerequisites
* A USB 3.0/3.1 flash drive (16GB+ recommended).
* **Ventoy**: [Download here](https://www.ventoy.net/en/download.html).
* **Ubuntu Server 24.04 LTS ISO**: [Download here](https://ubuntu.com/download/server).

### Step 1: Prepare the USB with Ventoy
1. Plug in your USB drive.
2. Run the Ventoy2Disk tool.
3. Select your drive and click **Install** (Warning: This wipes the drive).

### Step 2: Add the ISO
1. Open the newly created "Ventoy" drive in your file explorer.
2. Copy the `ubuntu-24.04-server-amd64.iso` file directly onto the root of the drive.

### Step 3: Configure Automation
1. Create a folder named `ventoy` on the USB drive.
2. Copy the `ventoy.json` and `user-data` files from this repository into that folder.
3. **Create a file named `meta-data`** in the same folder. You can leave it empty, or copy the contents from this repo to set the hostname.

The `user-data` file uses a hashed password for the initial build. 
* **Default Username:** `anakin`
* **Default Password:** `ubuntu`

To generate your own hash for a custom password, run `openssl passwd -6` (on Linux/WSL)

### Step 4: Boot
1. Plug the USB into the target laptop.
2. Boot from USB (usually F12, F2, or Del at startup).
3. Select the Ubuntu ISO from the Ventoy menu. The `user-data` configuration will take over from there.

