#!/bin/bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"

echo "🔧 Setting Xcode 16.0 as default with xcode-select..."
sudo xcode-select -s "${XCODE_PATH}"

DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT: $SDKROOT"

# Export for current shell
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

# Export for all future GitHub Actions steps
echo "DEVELOPER_DIR=$DEVELOPER_DIR" >> "$GITHUB_ENV"
echo "SDKROOT=$SDKROOT" >> "$GITHUB_ENV"

# Show effective paths
echo "✅ cc: $(xcrun -f cc)"
echo "✅ SDK Path via xcrun: $(xcrun --show-sdk-path)"
