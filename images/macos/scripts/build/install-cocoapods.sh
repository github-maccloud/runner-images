#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-cocoapods.sh
##  Desc:  Install Cocoapods
################################################################################
# DEBUG: view iana timezone version
echo "/usr/share"

echo "/usr/share/zoneinfo/+VERSION"
cat /usr/share/zoneinfo/+VERSION
echo "/usr/share/zoneinfo"
ls -la /usr/share/zoneinfo
echo "/var/db/timezone"
ls -la /var/db/timezone

# Setup the Cocoapods
echo "Installing Cocoapods..."
pod setup

# Create a symlink to /usr/local/bin since it was removed due to Homebrew change.
ln -sf $(which pod) /usr/local/bin/pod

invoke_tests "Common" "CocoaPods"
