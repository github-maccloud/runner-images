#!/bin/bash -e -o pipefail

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

arch=$(uname -m)
if [[ "$arch" == "arm64" ]]; then
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_arm64.zip"
else
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64.zip"
fi

echo "Compatible version of WebDriver: ${edge_driver_latest_version}"
edge_driver_archive_path=$(download_with_retry "$edge_driver_url")

TEMP_EDGE_DRIVER_DIR="$HOME/.msedgedriver"
EDGE_DRIVER_DIR="/usr/local/share/edge_driver"

mkdir -p "$TEMP_EDGE_DRIVER_DIR"
unzip -qq "$edge_driver_archive_path" -d "$TEMP_EDGE_DRIVER_DIR"

echo "Listing contents of TEMP_EDGE_DRIVER_DIR:"
ls -R "$TEMP_EDGE_DRIVER_DIR"

driver_path=$(find "$TEMP_EDGE_DRIVER_DIR" -type f -name "msedgedriver" | head -n 1)

if [[ -n "$driver_path" ]]; then
    sudo mkdir -p "$EDGE_DRIVER_DIR"
    sudo mv "$driver_path" "$EDGE_DRIVER_DIR/msedgedriver"
    sudo chmod +x "$EDGE_DRIVER_DIR/msedgedriver"
    sudo ln -sf "$EDGE_DRIVER_DIR/msedgedriver" /usr/local/bin/msedgedriver
else
    echo "Error: msedgedriver not found after unzipping."
    exit 1
fi

rm -rf "$TEMP_EDGE_DRIVER_DIR"
echo "export EDGEWEBDRIVER=${EDGE_DRIVER_DIR}" >> ${HOME}/.bashrc

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
