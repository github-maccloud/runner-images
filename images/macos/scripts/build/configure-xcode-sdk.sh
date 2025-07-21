#!/usr/bin/env bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Setting Xcode 16.0 as default with xcode-select..."
sudo xcode-select -s "$DEVELOPER_DIR"

echo "🧹 Removing Command Line Tools to avoid fallback..."
sudo rm -rf /Library/Developer/CommandLineTools

echo "🔧 Persisting DEVELOPER_DIR and SDKROOT system‑wide..."
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode.sh >/dev/null <<EOF
#!/bin/bash
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

sudo chmod +x /etc/profile.d/xcode.sh

# Export for this shell (optional, useful if running commands after this in same script)
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

# Export for GitHub Actions (if relevant)
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "🔄 Exporting to GITHUB_ENV for Actions…"
  echo "DEVELOPER_DIR=$DEVELOPER_DIR" >>"$GITHUB_ENV"
  echo "SDKROOT=$SDKROOT" >>"$GITHUB_ENV"
fi

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT:       $SDKROOT"
echo "✅ xcode-select:  $(xcode-select -p)"
echo "✅ xcrun:         $(xcrun --find cc)"
echo "✅ SDK path:      $(xcrun --show-sdk-path)"
echo "✅ clang:         $(clang --version | head -n1)"
