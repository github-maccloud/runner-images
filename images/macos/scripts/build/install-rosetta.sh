#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-rosetta.sh
##  Desc:  Install Rosetta
################################################################################
# DEBUG: view iana timezone version
echo "/usr/share"

echo "/usr/share/zoneinfo/+VERSION"
cat /usr/share/zoneinfo/+VERSION
echo "/usr/share/zoneinfo"
ls -la /usr/share/zoneinfo
echo "/var/db/timezone"
ls -la /var/db/timezone

echo "Installing Rosetta"
/usr/sbin/softwareupdate --install-rosetta --agree-to-license
