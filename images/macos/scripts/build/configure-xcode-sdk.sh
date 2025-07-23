#!/bin/bash
set -euo pipefail

# Xcode version to set as default
XCODE_VERSION="16"
XCODE_PATH="/Applications/Xcode_${XCODE_VERSION}.app"
DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Setting Xcode $XCODE_VERSION as default with xcode-select..."
sudo xcode-select -s "$DEVELOPER_DIR"

# Export for current shell
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT: $SDKROOT"

# Create profile.d script to persist across login shells
echo "💾 Writing to /etc/profile.d/xcode-sdk.sh..."
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

# ✅ Source the profile.d script in shell RCs for GitHub Actions runtime
echo "🔁 Ensuring all shells source xcode-sdk.sh..."
echo "source /etc/profile.d/xcode-sdk.sh" | sudo tee -a /etc/bashrc /etc/zshrc >/dev/null

# 🔍 Validation in current shell
echo "🧪 Validating in current shell:"
echo "✅ xcode-select path     : $(xcode-select -p)"
echo "✅ xcrun cc path         : $(xcrun -f cc)"
echo "✅ SDK path via xcrun    : $(xcrun --show-sdk-path)"
echo "✅ Clang version         : $(clang --version | head -n1)"
echo "✅ Current SDKROOT       : $SDKROOT"

# 🧪 Validate in a new login shell (simulate GitHub Actions behavior)
echo "🧪 Verifying in a fresh login shell:"
bash -l -c 'echo "🧪 [Login Shell] SDKROOT=$SDKROOT"; echo "🧪 [Login Shell] SDK via xcrun: $(xcrun --show-sdk-path)"'
