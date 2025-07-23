#!/bin/bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
DEVELOPER_DIR="$XCODE_PATH/Contents/Developer"
SDKROOT="$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Setting Xcode 16.0 as default with xcode-select..."
sudo xcode-select -s "$DEVELOPER_DIR"

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT: $SDKROOT"

# Export for current session
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

# Persist for future login shells
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

# GitHub Actions support (only works there)
if [ -n "${GITHUB_ENV:-}" ]; then
  echo "DEVELOPER_DIR=$DEVELOPER_DIR" >> "$GITHUB_ENV"
  echo "SDKROOT=$SDKROOT" >> "$GITHUB_ENV"
fi

# Confirm
echo "✅ cc: $(xcrun -f cc)"
echo "✅ clang: $(which clang)"
echo "✅ SDK Path via xcrun: $(xcrun --show-sdk-path)"
