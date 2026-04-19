#!/bin/bash

echo "################################################################"
echo "################################################################"
echo "####                public-bootstrap.sh                     ####"
echo "################################################################"
echo "Starting public bootstrap script..."
echo "################################################################"

touch /usr/local/bin/public_bootstrap_ran


# Ensure we run with elevated privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

export DEBIAN_FRONTEND=noninteractive
USER_NAME="anakin"
USER_HOME="/home/$USER_NAME"

# Move wifi connection to private-bootstrap
# echo "--- Checking Connectivity ---"
# # Check if already connected, otherwise attempt connection
# if ! nmcli -t -f active,ssid dev wifi | grep -q "^yes:SSID"; then
#     echo "Connecting to SSID..."
#     nmcli dev wifi connect "SSID" password "WIFI_PASSWORD" || echo "Wifi connection failed, continuing..."
# fi

echo "--- Configuring External Repositories ---"
# Create keyring directory if missing
mkdir -p -m 755 /etc/apt/keyrings

# Add Microsoft GPG key if not present
if [ ! -f /etc/apt/keyrings/microsoft.gpg ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
fi

# Add Repo lists only if they don't exist
[ -f /etc/apt/sources.list.d/vscode.list ] || echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
[ -f /etc/apt/sources.list.d/microsoft-edge.list ] || echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list

echo "--- Syncing Packages ---"
apt-get update
apt-get install -y \
    ubuntu-desktop-minimal \
    libreoffice \
    code \
    microsoft-edge-stable

echo "--- Configuring PWA Launchers ---"
APP_DIR="$USER_HOME/.local/share/applications"
mkdir -p "$APP_DIR"

# Helper function to create desktop entries idempotently
create_desktop_entry() {
    local FILE="$APP_DIR/$1"
    local NAME=$2
    local URL=$3
    cat <<EOF > "$FILE"
[Desktop Entry]
Name=$NAME
Exec=microsoft-edge-stable --app=$URL
Icon=browser
Terminal=false
Type=Application
Categories=Network;Chat;
EOF
}

create_desktop_entry "whatsapp.desktop" "WhatsApp" "https://web.whatsapp.com"
create_desktop_entry "teams.desktop" "Microsoft Teams" "https://teams.microsoft.com"

# Ensure permissions are correct
chown -R $USER_NAME:$USER_NAME "$USER_HOME/.local"

echo "--- System Pruning ---"
# Remove Snap only if it is still installed
if dpkg -l | grep -q "^ii  snapd"; then
    apt-get purge -y snapd
    rm -rf "$USER_HOME/snap"
    rm -rf /var/cache/snapd/
fi

# Remove fonts if they still exist
dpkg -l | grep -q "^ii  fonts-noto-extra" && apt-get purge -y fonts-noto-extra
dpkg -l | grep -q "^ii  fonts-noto-cjk" && apt-get purge -y fonts-noto-cjk

# Final cleanup
apt-get autoremove -y --purge
apt-get clean


echo "################################################################"
echo "################################################################"
echo "####                public-bootstrap.sh                     ####"
echo "################################################################"
echo "Public Bootstrap Sequence Complete"
echo "################################################################"


