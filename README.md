# Laptop as code

The `laptop-as-code` project is essentially a procedure to build a laptop.

The laptop is designed as a Stateless Container. It has a base image, a configured environment, and a volatile "runtime" state that exists only between hydrate.sh and power-off.

The build process aims to be fully automated, but pragmatism requires some interaction during the build.

---

## Runtime process

1. Run `hydrate.sh` to pull repos and ephemeral data into RAM/Disk.
2. Power off. **Local data is discarded; only pushed code survives.**

---

## Build process

1. Install the OS using a cloud-init user-data script.
2. Run `public-bootstrap.sh` to install software.
3. Run `private-bootstrap.sh` to configure Keys, Wifi and Secrets.

---


## Step 0 - Prepare two USB sticks

### Operating system
Download the latest Ubuntu Server ISO, and write it to a USB using Rufus

### User-data
Replace the username and password in the sample `user-data` file
```bash
# Create the password hash
openssl passwd -6 -salt $(openssl rand -base64 12) "my-password"
```

TIP: If you make changes to user-data, you can use `cloud-init schema` to validate the file without waiting for the OS to install.
```bash
# Install validation tools for validation
sudo apt update && sudo apt install cloud-init -y

# Validate schema
USER_DATA="/home/anakin/projects/laptop-as-code/version1/user-data"
clear && sudo cloud-init schema --config-file "$USER_DATA" --annotate
```
Create the USB:
- Format a seperate USB as fat32, and label `CIDATA`.
- Copy `user-data` to the root
- Create an empty file `meta-data` at the root



## Step 1 - Install Ubuntu
Plug in both USBs and ethernet, then run the installer

The OS will install, then the laptop will reboot, pick up DHCP, and then download an run the public bootstrap script.

### Connect
The laptop should land on the welcome screen with your user account. Enter the password that you configured in user-data to log in.
SSH server should also be installed, so you may also choose to connect over SSH



## Step 2 - Public bootstrap
When `cloud-init` runs, it fetches the public bootstrap script from GitHub. For development you mak wish to avoid commit & push for every minor itteration.

Serve the script from a dev server
```bash
cd /home/anakin/projects/laptop-as-code/version1
sudo python3 -m http.server 80
```

The bootstrap script is desigend to be idempotent. Make changes, then re-run.
```bash
curl -sL http://10.0.1.41/public-bootstrap.sh | sudo bash
```



## Step 3 - Private bootstrap
TODO: Download and run a private bootstrap

This stage will personalise the new machine.
- Browser favourites
- Remote hosts for VS Code



## TODO

### General
- Can we use a single partitioned USB for both OS and user-data?

### Public
- VS Code Extension: Remote - SSH
- AWSCLI
- WiFi
- Passwordless sudo and SSH security
- 


### Private
- VS Code Remote Hosts




