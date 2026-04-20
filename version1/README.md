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


## Step 0 - Prepare user-data
```bash
USER_DATA="/home/anakin/projects/laptop-as-code/version1/user-data"

# install validation tools for validation
sudo apt update && sudo apt install cloud-init -y

# Validate schema
clear && sudo cloud-init schema --config-file "$USER_DATA" --annotate
```



## Step 1 - Install Ubuntu
- Create install USB from Ubuntu Server iso using rufus
- Format a second USB fat32 with label `whatever`, and add user-data and meta-data
- Plug in both USBs and ethernet, then run the installer

The OS will install, then the laptop will reboot and pick up DHCP.
Connect over SSH with the user and password from user-data

Create the password hash
```bash
openssl passwd -6 -salt $(openssl rand -base64 12) "my-password"
```

## Step 2 - Public bootstrap
TODO: Download and run a public bootstrap
- WiFi
- Passwordless sudo and other basic security settings
- Desktop environment
- Packages

This step should be idempotent

Serve the script here for now:
```bash
sudo python3 -m http.server 80
```

Run
```bash
curl -sL http://10.0.1.41/public-bootstrap.sh | sudo bash
```


## Step 3 - Private bootstrap
TODO: Download and run a private bootstrap

This stage might be ehpemeral




