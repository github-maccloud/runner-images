#!/bin/bash
set -euo pipefail

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

# Persist to profile.d (login shells)
echo "💾 Writing to /etc/profile.d/xcode-sdk.sh..."
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

# Source it in bash/zsh rc files
echo "🔁 Appending source to shell RCs..."
echo "source /etc/profile.d/xcode-sdk.sh" | sudo tee -a /etc/bashrc /etc/zshrc >/dev/null

# 🔐 Persist to /etc/zshenv (for GitHub Actions, non-login shells)
echo "🔐 Writing to /etc/zshenv..."
sudo tee -a /etc/zshenv >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

# 🧪 Current shell validation
echo "🧪 Validating in current shell:"
echo "✅ xcode-select path     : $(xcode-select -p)"
echo "✅ xcrun cc path         : $(xcrun -f cc)"
echo "✅ SDK path via xcrun    : $(xcrun --show-sdk-path)"
echo "✅ Clang version         : $(clang --version | head -n1)"
echo "✅ Current SDKROOT       : $SDKROOT"

# 🧪 Validate in login shell
echo "🧪 Validating in login shell:"
bash -l -c 'echo "✅ [Login Shell] SDKROOT=$SDKROOT"; echo "✅ [Login Shell] xcrun: $(xcrun --show-sdk-path)"'

# 🧪 Validate in non-login shell
echo "🧪 Validating in non-login shell:"
zsh -c 'echo "✅ [Non-login zsh] SDKROOT=$SDKROOT"; echo "✅ [Non-login zsh] xcrun: $(xcrun --show-sdk-path)"'
