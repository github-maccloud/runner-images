#!/usr/bin/env bash
set -euo pipefail

XCODE_PATH="/Applications/Xcode_16.app"
DEVELOPER_DIR="${XCODE_PATH}/Contents/Developer"
SDKROOT="${DEVELOPER_DIR}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

echo "🔧 Setting Xcode 16.0 as default with xcode-select..."
sudo xcode-select -s "$DEVELOPER_DIR"

echo "🔧 Persisting DEVELOPER_DIR + SDKROOT system‑wide..."
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/xcode-sdk.sh >/dev/null <<EOF
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"
EOF

# If we're running in GitHub Actions, also export into $GITHUB_ENV—but only if it's defined:
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "🔄 Exporting to GITHUB_ENV for Actions…"
  echo "DEVELOPER_DIR=$DEVELOPER_DIR" >>"$GITHUB_ENV"
  echo "SDKROOT=$SDKROOT"         >>"$GITHUB_ENV"
fi

# And export for _this_ shell, so any following commands in this script
# immediately pick up the right SDK:
export DEVELOPER_DIR="$DEVELOPER_DIR"
export SDKROOT="$SDKROOT"

echo "✅ DEVELOPER_DIR: $DEVELOPER_DIR"
echo "✅ SDKROOT:       $SDKROOT"
echo "✅ xcode-select:  $(xcode-select -p)"
echo "✅ cc:            $(xcrun -f cc)"
echo "✅ SDK path:      $(xcrun --show-sdk-path)"
echo "✅ clang:         $(clang --version | head -n1)"
