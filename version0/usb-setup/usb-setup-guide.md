# USB Setup Guide

Follow these steps to create the automated bootable USB for this environment.

### Pre-requisites
* A USB 3.0/3.1 flash drive (16GB+ recommended).

### Step 1: Prepare the USB with Ventoy
* **Ventoy**: [Download here](https://www.ventoy.net/en/download.html).
1. Plug in your USB drive.
2. Run the Ventoy2Disk tool.
3. Select your drive and click **Install** (Warning: This wipes the drive).

### Step 2: Add the ISO
* **Ubuntu Server 24.04 LTS ISO**: [Download here](https://ubuntu.com/download/server).
1. Open the newly created "Ventoy" drive in your file explorer.
2. Copy the `ubuntu-24.04-server-amd64.iso` file directly onto the root of the drive.

### Step 3: Add the Persistence drive
Run the commands below to create a empty persistence drive
```bash
# Allocate, format, and label and zip the 4GB container
cd ~/projects/laptop-as-code
fallocate -l 4G persistence.dat
mkfs.ext4 persistence.dat
e2label persistence.dat casper-rw
zip persistence.zip persistence.dat
```

- Download the zip to your local machine (winSCP)
- Extract to local drive
- Copy to USB (will take some time)
- Verify that the file inflated correctly
```powershell
# It must be exactly: 4294967296
(Get-Item D:\persistence.dat).Length
```


### Step 4: Configure Automation
1. Create a folder named `ventoy` on the USB drive.
2. Create `ventoy/ventoy.json`.




### Step 4: Boot
1. Plug the USB into the target laptop.
2. Boot from USB (usually F12, F2, or Del at startup).
3. Select the Ubuntu ISO from the Ventoy menu. The `user-data` configuration will take over from there.



File Creation (Run in Repo Root)
```bash
# Allocate, format, and label the 4GB container
fallocate -l 4G persistence.dat
mkfs.ext4 persistence.dat
e2label persistence.dat casper-rw
```

Move: Copy to the root of the Ventoy USB.