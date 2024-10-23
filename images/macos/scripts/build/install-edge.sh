#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-edge.sh
##  Desc:  Install Microsoft Edge browser and WebDriver
################################################################################

source ~/utils/utils.sh

echo "Installing Microsoft Edge..."
brew install --cask microsoft-edge

# Verify if Microsoft Edge is installed
EDGE_INSTALLATION_PATH="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
if [ ! -f "$EDGE_INSTALLATION_PATH" ]; then
    echo "Microsoft Edge installation failed or path is incorrect."
    exit 1
fi

# Get the installed Edge version
edge_version=$("$EDGE_INSTALLATION_PATH" --version | cut -d' ' -f 3)
edge_version_major=$(echo $edge_version | cut -d'.' -f 1)

echo "Installed version of Microsoft Edge: ${edge_version}"

echo "Installing Microsoft Edge WebDriver..."

# Download the latest compatible WebDriver version for the installed Edge version
edge_driver_version_file_path=$(download_with_retry "https://msedgedriver.azureedge.net/LATEST_RELEASE_${edge_version_major}_MACOS")
if [ ! -f "$edge_driver_version_file_path" ]; then
    echo "Failed to download WebDriver version information."
    exit 1
fi

# Get the latest WebDriver version and construct the download URL
edge_driver_latest_version=$(iconv -f utf-16 -t utf-8 "$edge_driver_version_file_path" | tr -d '\r')
edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64.zip"

echo "Compatible WebDriver version: ${edge_driver_latest_version}"

# Download the WebDriver binary
edge_driver_archive_path=$(download_with_retry "$edge_driver_url")
if [ ! -f "$edge_driver_archive_path" ]; then
    echo "Failed to download WebDriver."
    exit 1
fi

# Set the directory for the Edge WebDriver
EDGE_DRIVER_DIR="/usr/local/share/edge_driver"
mkdir -p $EDGE_DRIVER_DIR
unzip -qq $edge_driver_archive_path -d $EDGE_DRIVER_DIR

# Symlink the WebDriver to /usr/local/bin for easy access
ln -sf $EDGE_DRIVER_DIR/msedgedriver /usr/local/bin/msedgedriver

# Set environment variable for WebDriver path
echo "export EDGEWEBDRIVER=${EDGE_DRIVER_DIR}" >> ${HOME}/.bashrc
export EDGEWEBDRIVER="${EDGE_DRIVER_DIR}"

echo "Edge WebDriver installed successfully."

# Configure Edge Updater to prevent automatic updates
sudo mkdir -p "/Library/Managed Preferences"

sudo tee "/Library/Managed Preferences/com.microsoft.EdgeUpdater.plist" > /dev/null <<EOF
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

# Set ownership of the preferences file
sudo chown root:wheel "/Library/Managed Preferences/com.microsoft.EdgeUpdater.plist"

echo "Microsoft Edge WebDriver and Edge Updater configuration completed."

# Run tests to verify the installation
invoke_tests "Browsers" "Edge"
