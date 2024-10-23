#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-edge.sh
##  Desc:  Install Microsoft Edge browser and WebDriver based on system architecture
################################################################################

source ~/utils/utils.sh

# Detect system architecture
arch=$(get_arch)

# Install Microsoft Edge browser using Homebrew
echo "Installing Microsoft Edge..."
brew install --cask microsoft-edge

# Verify if Edge is installed
EDGE_INSTALLATION_PATH="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
if [ ! -f "$EDGE_INSTALLATION_PATH" ]; then
    echo "Microsoft Edge installation failed or path is incorrect."
    exit 1
fi

# Get installed version of Edge
edge_version=$("$EDGE_INSTALLATION_PATH" --version | cut -d' ' -f 3)
edge_version_major=$(echo $edge_version | cut -d'.' -f 1)

echo "Installed version of Microsoft Edge: ${edge_version}"

# Install Microsoft Edge WebDriver
echo "Installing Microsoft Edge WebDriver..."

# Fetch the latest compatible WebDriver version for the installed Edge
edge_driver_version_file_path=$(download_with_retry "https://msedgedriver.azureedge.net/LATEST_RELEASE_${edge_version_major}_MACOS")
edge_driver_latest_version=$(iconv -f utf-16 -t utf-8 "$edge_driver_version_file_path" | tr -d '\r')

# Determine the correct WebDriver download URL based on architecture
if [[ $arch == "arm64" ]]; then
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_arm64.zip"
else
    edge_driver_url="https://msedgedriver.azureedge.net/${edge_driver_latest_version}/edgedriver_mac64.zip"
fi

echo "Compatible WebDriver version: ${edge_driver_latest_version}"

# Download the WebDriver
edge_driver_archive_path=$(download_with_retry "$edge_driver_url")
if [ ! -f "$edge_driver_archive_path" ]; then
    echo "Failed to download WebDriver."
    exit 1
fi

# Create directory for Edge WebDriver
EDGE_DRIVER_DIR="/usr/local/share/edge_driver"
sudo mkdir -p $EDGE_DRIVER_DIR

# Unzip WebDriver to the target directory
unzip -qq $edge_driver_archive_path -d $EDGE_DRIVER_DIR

# Create symlink for easy access to WebDriver
sudo ln -sf $EDGE_DRIVER_DIR/msedgedriver /usr/local/bin/msedge
