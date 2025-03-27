#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-edge.sh
##  Desc:  Install edge browser for both Intel and ARM64 architectures
################################################################################

source ~/utils/utils.sh

echo "Installing Microsoft Edge..."
brew install --cask microsoft-edge

EDGE_INSTALLATION_PATH="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
edge_version=$("$EDGE_INSTALLATION_PATH" --version | cut -d' ' -f 3)
edge_version_major=$(echo $edge_version | cut -d'.' -f 1)

echo "Version of Microsoft Edge: ${edge_version}"

echo "Installing Microsoft Edge WebDriver..."

arch_name="$(uname -m)"
if [[ "$arch_name" == "arm64" ]]; then
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64_m1.zip"
else
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64.zip"
fi

echo "Compatible version of WebDriver: ${edge_driver_latest_version}"

edge_driver_archive_path=$(download_with_retry "$edge_driver_url")

EDGE_DRIVER_DIR="/usr/local/share/edge_driver"
mkdir -p $EDGE_DRIVER_DIR
unzip -qq $edge_driver_archive_path -d $EDGE_DRIVER_DIR
ln -s $EDGE_DRIVER_DIR/msedgedriver /usr/local/bin/msedgedriver

echo "export EDGEWEBDRIVER=${EDGE_DRIVER_DIR}" >> ${HOME}/.bashrc

# Configure Edge Updater to prevent auto update
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
