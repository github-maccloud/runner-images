#!/bin/bash -e -o pipefail
################################################################################
##  File:  configure-xcode-sdk.sh
##  Desc:  Set the default Xcode SDK path (instead of Command Line Tools)
##         by updating xcode-select and globally exporting DEVELOPER_DIR
################################################################################

echo "🔧 Configuring Xcode SDK..."

TOOLSET_FILE="/Users/runner/image-generation/toolset.json"
if [[ ! -f "$TOOLSET_FILE" ]]; then
    echo "❌ toolset.json not found at $TOOLSET_FILE"
    exit 1
fi

DEFAULT_XCODE_VERSION=$(jq -r '.xcode.default' "$TOOLSET_FILE")
XCODE_PATH="/Applications/Xcode_${DEFAULT_XCODE_VERSION}.app/Contents/Developer"

if [[ ! -d "$XCODE_PATH" ]]; then
    echo "❌ Xcode path $XCODE_PATH does not exist."
    exit 1
fi

echo "🔄 Setting xcode-select to: $XCODE_PATH"
sudo xcode-select -s "$XCODE_PATH"

CURRENT_SELECT=$(xcode-select -p)
if [[ "$CURRENT_SELECT" != "$XCODE_PATH" ]]; then
    echo "❌ xcode-select did not update correctly. Expected: $XCODE_PATH, Got: $CURRENT_SELECT"
    exit 1
fi

echo "✅ xcode-select now points to: $CURRENT_SELECT"

# Persist DEVELOPER_DIR globally for login shells
PROFILE_SCRIPT="/etc/profile.d/developer_dir.sh"
echo "🌍 Writing DEVELOPER_DIR to $PROFILE_SCRIPT"
echo "export DEVELOPER_DIR=\"$XCODE_PATH\"" | sudo tee "$PROFILE_SCRIPT" > /dev/null
sudo chmod +x "$PROFILE_SCRIPT"

# Debug output
echo "🧪 Verifying SDK configuration..."
echo "✅ xcrun path             : $(xcrun -f cc)"
echo "✅ SDK path               : $(xcrun --show-sdk-path)"
echo "✅ Clang version          : $(clang --version | head -n1)"
echo "✅ DEVELOPER_DIR exported : $DEVELOPER_DIR"
