#!/bin/bash
set -euo pipefail

# Use xcode-select to make sure Xcode is selected
echo "🔧 Setting Xcode as default with xcode-select..."
sudo xcode-select -s "/Applications/Xcode.app/Contents/Developer"

# Optional: export DEVELOPER_DIR to ensure consistency
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
echo "✅ DEVELOPER_DIR set to $DEVELOPER_DIR"

# Show paths
echo "✅ SDK Path: $(xcrun --sdk macosx --show-sdk-path)"
echo "✅ cc: $(xcrun -f cc)"
echo "✅ c++: $(xcrun -f c++)"
echo "✅ ld: $(xcrun -f ld)"
