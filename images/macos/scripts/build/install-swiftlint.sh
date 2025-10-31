#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-swiftlint.sh
##  Desc:  Install SwiftLint
################################################################################
# DEBUG: view iana timezone version
echo "/usr/share"

echo "/usr/share/zoneinfo/+VERSION"
cat /usr/share/zoneinfo/+VERSION
echo "/usr/share/zoneinfo"
ls -la /usr/share/zoneinfo
echo "/var/db/timezone"
ls -la /var/db/timezone

source ~/utils/utils.sh

echo "Installing Swiftlint..."

brew_smart_install "swiftlint"

invoke_tests "Linters" "SwiftLint"
