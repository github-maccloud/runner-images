#!/bin/bash
set -euo pipefail

XCODE_VERSION="16"
XCODE_PATH="/Applications/Xcode_${XCODE_VERSION}.app"
DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Setting Xcode $XCODE_VERSION as default using xcode-select..."
sudo xcode-select -s "$DEVELOPER_DIR"

# Export for current shell
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT: $SDKROOT"

# Persist environment vars for login shells
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

# Force it to be sourced even in non-login shells (like GitHub Actions)
echo "💾 Ensuring all future shells source Xcode SDK vars..."
echo "source /etc/profile.d/xcode-sdk.sh" | sudo tee -a /etc/bashrc >/dev/null

# Final verification
echo "🧪 Final validation:"
echo "✅ xcode-select path     : $(xcode-select -p)"
echo "✅ xcrun cc path         : $(xcrun -f cc)"
echo "✅ SDK path via xcrun    : $(xcrun --show-sdk-path)"
echo "✅ Clang version         : $(clang --version | head -n1)"
