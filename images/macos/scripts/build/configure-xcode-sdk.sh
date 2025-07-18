#!/bin/bash
set -euo pipefail

echo " Setting Xcode as default with xcode-select..."
sudo xcode-select -s /Applications/Xcode.app

DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo " DEVELOPER_DIR: $DEVELOPER_DIR"
echo " SDKROOT: $SDKROOT"

# Export for current shell
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

# Export for all future GitHub Actions steps
echo "DEVELOPER_DIR=$DEVELOPER_DIR" >> "$GITHUB_ENV"
echo "SDKROOT=$SDKROOT" >> "$GITHUB_ENV"

# Show effective paths
echo " cc: $(xcrun -f cc)"
echo " SDK Path via xcrun: $(xcrun --show-sdk-path)"
