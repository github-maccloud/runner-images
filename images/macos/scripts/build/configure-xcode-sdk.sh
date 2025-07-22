#!/bin/bash -e -o pipefail

echo "🔧 Forcing xcode-select to point to Xcode..."

DEFAULT_XCODE_VERSION=$(jq -r '.xcode.default' /Users/runner/image-generation/toolset.json)
XCODE_PATH="/Applications/Xcode_${DEFAULT_XCODE_VERSION}.app/Contents/Developer"

if [[ ! -d "$XCODE_PATH" ]]; then
    echo "❌ Xcode path $XCODE_PATH does not exist."
    exit 1
fi

sudo xcode-select -s "$XCODE_PATH"

echo "✅ xcode-select now points to: $(xcode-select -p)"
