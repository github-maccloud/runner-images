#!/bin/bash

set -e

# Define variables
EDGE_DRIVER_URL_BASE="https://msedgedriver.azureedge.net"
INSTALL_DIR="/usr/local/share/edge_driver"
TEMP_DIR="/tmp/edge_driver"

# Determine the system architecture
ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" ]]; then
    DRIVER_ARCH="arm64"
elif [[ "$ARCH" == "x86_64" ]]; then
    DRIVER_ARCH="x64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

echo "Detected architecture: $ARCH ($DRIVER_ARCH)"

# Fetch the latest version
echo "Fetching the latest Edge Driver version..."
LATEST_VERSION=$(curl -s "https://msedgedriver.azureedge.net/LATEST_RELEASE")
if [[ -z "$LATEST_VERSION" ]]; then
    echo "Failed to fetch the latest version. Check your internet connection."
    exit 1
fi

echo "Latest Edge Driver version: $LATEST_VERSION"

# Construct the download URL
EDGE_DRIVER_URL="$EDGE_DRIVER_URL_BASE/$LATEST_VERSION/edgedriver_$DRIVER_ARCH.zip"

# Create necessary directories
mkdir -p "$TEMP_DIR"
mkdir -p "$INSTALL_DIR"

# Download Edge Driver
echo "Downloading Microsoft Edge Driver from $EDGE_DRIVER_URL..."
curl -L -o "$TEMP_DIR/edgedriver.zip" "$EDGE_DRIVER_URL"

# Extract the driver
echo "Extracting Microsoft Edge Driver..."
unzip -o "$TEMP_DIR/edgedriver.zip" -d "$INSTALL_DIR"

# Cleanup temporary files
rm -rf "$TEMP_DIR"

# Add the driver to PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo "export PATH=\$PATH:$INSTALL_DIR" >> ~/.bash_profile
    source ~/.bash_profile
fi

# Verify installation
echo "Microsoft Edge Driver installed at $INSTALL_DIR"
echo "Driver version:"
"$INSTALL_DIR/msedgedriver" --version
