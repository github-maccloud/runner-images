#!/usr/bin/env bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Setting Xcode 16 as default with xcode-select..."
sudo xcode-select -s "$DEVELOPER_DIR"

echo "🔧 Persisting DEVELOPER_DIR and SDKROOT system-wide..."

# Create profile.d file to persist env vars across shells
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
#!/bin/bash
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF
sudo chmod +x /etc/profile.d/xcode-sdk.sh

# Export in current shell (for any further provisioning steps)
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

# Export to GitHub Actions env if running in CI
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "DEVELOPER_DIR=$DEVELOPER_DIR" >> "$GITHUB_ENV"
  echo "SDKROOT=$SDKROOT"             >> "$GITHUB_ENV"
fi

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT:       $SDKROOT"
echo "✅ xcode-select:  $(xcode-select -p)"
echo "✅ cc:            $(xcrun -f cc)"
echo "✅ SDK path:      $(xcrun --show-sdk-path)"
echo "✅ clang:         $(clang --version | head -n1)"
