#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-edge.sh
##  Desc:  Install Microsoft Edge and WebDriver for both Intel and ARM64 Macs
################################################################################

source ~/utils/utils.sh

echo "Installing Microsoft Edge..."
brew install --cask microsoft-edge

EDGE_INSTALLATION_PATH="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
edge_version=$("$EDGE_INSTALLATION_PATH" --version | cut -d' ' -f 3)
edge_version_major=$(echo $edge_version | cut -d'.' -f 1)

echo "Version of Microsoft Edge: ${edge_version}"

echo "Installing Microsoft Edge WebDriver..."
edge_driver_version_file_path=$(download_with_retry "https://msedgedriver.azureedge.net/LATEST_RELEASE_${edge_version_major}_MACOS")
edge_driver_latest_version=$(iconv -f utf-16 -t utf-8 "$edge_driver_version_file_path" | tr -d '\r')

edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64.zip"
echo "Downloading WebDriver from: $edge_driver_url"

edge_driver_archive_path=$(download_with_retry "$edge_driver_url")

# Ensure directory exists with proper permissions
EDGE_DRIVER_DIR="/usr/local/share/edge_driver"
if [ ! -d "$EDGE_DRIVER_DIR" ]; then
    sudo mkdir -p $EDGE_DRIVER_DIR
    sudo chown $(whoami) $EDGE_DRIVER_DIR
fi

# Extract WebDriver
unzip -qq $edge_driver_archive_path -d $EDGE_DRIVER_DIR
sudo chmod +x $EDGE_DRIVER_DIR/msedgedriver
sudo ln -sf $EDGE_DRIVER_DIR/msedgedriver /usr/local/bin/msedgedriver

echo "export EDGEWEBDRIVER=${EDGE_DRIVER_DIR}" >> ${HOME}/.bashrc

# Verify architecture
installed_arch=$(lipo -info "$EDGE_DRIVER_DIR/msedgedriver")
echo "Edge WebDriver installed with architectures: $installed_arch"

# Configure Edge Updater to prevent auto-update
sudo mkdir -p "/Library/Managed Preferences"

cat <<EOF | sudo tee "/Library/Managed Preferences/com.microsoft.EdgeUpdater.plist" > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>updatePolicies</key>
    <dict>
        <key>global</key>
        <dict>
            <key>UpdateDefault</key>
            <integer>3</integer>
        </dict>
    </dict>
</dict>
</plist>
EOF

sudo chown root:wheel "/Library/Managed Preferences/com.microsoft.EdgeUpdater.plist"

invoke_tests "Browsers" "Edge"
