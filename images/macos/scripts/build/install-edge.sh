#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-edge.sh
##  Desc:  Install edge browser and compatible WebDriver
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

# Determine correct WebDriver URL based on architecture
arch=$(uname -m)
if [[ "$arch" == "arm64" ]]; then
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_arm64.zip"
else
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64.zip"
fi

echo "Compatible version of WebDriver: ${edge_driver_latest_version}"
echo "Downloading from: $edge_driver_url"

edge_driver_archive_path=$(download_with_retry "$edge_driver_url")

TEMP_EDGE_DRIVER_DIR=$(mktemp -d)
unzip -qq "$edge_driver_archive_path" -d "$TEMP_EDGE_DRIVER_DIR"

echo "Listing contents of TEMP_EDGE_DRIVER_DIR:"
ls -R "$TEMP_EDGE_DRIVER_DIR"

driver_path=$(find "$TEMP_EDGE_DRIVER_DIR" -type f -name "msedgedriver.exe" | head -n 1)

if [[ -n "$driver_path" ]]; then
    EDGE_DRIVER_DIR="/usr/local/share/edge_driver"
    sudo mkdir -p "$EDGE_DRIVER_DIR"
    sudo mv "$driver_path" "$EDGE_DRIVER_DIR/msedgedriver"
    sudo chmod +x "$EDGE_DRIVER_DIR/msedgedriver"
    sudo ln -sf "$EDGE_DRIVER_DIR/msedgedriver" /usr/local/bin/msedgedriver
else
    echo "Error: msedgedriver not found after unzipping."
    exit 1
fi

echo "export EDGEWEBDRIVER=${EDGE_DRIVER_DIR}" >> ${HOME}/.bashrc

# Configure Edge Updater to prevent auto update
sudo mkdir -p "/Library/Managed Preferences"

cat <<EOF | sudo tee "/Library/Managed Preferences/com.microsoft.EdgeUpdater.plist" > /dev/null
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
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
