#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-xcbeautify.sh
##  Desc:  Install xcbeautify
################################################################################

source ~/utils/utils.sh

echo "Installing xcbeautify..."
# xcbeautify 3.1* requires Xcode 16.3 or higher
# pin to 2.3.1 for macOS 14
if is_Sonoma; then
    tool_commit="ea85fd1ef3aa6d60aabf5313989b3d0d68b48cd2"
    tool_rb_link="https://raw.githubusercontent.com/Homebrew/homebrew-core/$tool_commit/Formula/x/xcbeautify.rb"
    tool_rb_path=$(download_with_retry "$tool_rb_link")
    brew install "$tool_rb_path"
else
    brew_smart_install xcbeautify
fi
