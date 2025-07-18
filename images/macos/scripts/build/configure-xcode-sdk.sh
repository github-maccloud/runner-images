#!/bin/bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
XCODE_DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
XCODE_SDK_PATH="${XCODE_DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Switching to Xcode 16 at: ${XCODE_PATH}"
sudo xcode-select -s "${XCODE_DEVELOPER_DIR}"

echo "🔧 Setting environment variables system-wide..."
sudo mkdir -p /etc/profile.d

sudo tee /etc/profile.d/xcode-sdk.sh > /dev/null <<EOF
export DEVELOPER_DIR="${XCODE_DEVELOPER_DIR}"
export SDKROOT="${XCODE_SDK_PATH}"
EOF

echo "✅ DEVELOPER_DIR: ${XCODE_DEVELOPER_DIR}"
echo "✅ SDKROOT:       ${XCODE_SDK_PATH}"
echo "✅ cc path:       $(which cc)"
echo "✅ SDK path:      $(xcrun --show-sdk-path)"
echo "✅ xcode-select:  $(xcode-select -p)"
echo "✅ Apple clang:   $(clang --version | head -n 1)"
