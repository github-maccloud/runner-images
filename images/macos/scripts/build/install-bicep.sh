#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-bicep.sh
##  Desc:  Install bicep cli
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

echo "Installing bicep cli..."
brew tap azure/bicep
brew_smart_install bicep

invoke_tests "Common" "Bicep"
