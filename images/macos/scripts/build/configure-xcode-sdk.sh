#!/usr/bin/env bash
set -euo pipefail

XCODE_DIR="/Applications/Xcode_16.app/Contents/Developer"
SDKPATH="$XCODE_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

sudo xcode-select -s "$XCODE_DIR"

sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="$XCODE_DIR"
export SDKROOT="$SDKPATH"
EOF

sudo chmod +x /etc/profile.d/xcode-sdk.sh

# Immediate effect for this script
export DEVELOPER_DIR="$XCODE_DIR"
export SDKROOT="$SDKPATH"

echo "✅ xcode-select → $(xcode-select -p)"
echo "✅ xcrun sdk     → $(xcrun --show-sdk-path)"
