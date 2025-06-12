#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-cocoapods.sh
##  Desc:  Install Cocoapods
################################################################################

source ~/utils/utils.sh

# Setup the Cocoapods
echo "Installing Cocoapods..."
pod setup
track_component_size "cocoapods"

# Create a symlink to /usr/local/bin since it was removed due to Homebrew change.
ln -sf $(which pod) /usr/local/bin/pod

invoke_tests "Common" "CocoaPods"
