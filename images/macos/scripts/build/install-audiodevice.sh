#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-audiodevice.sh
##  Desc:  Install audio device
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

echo "install switchaudio-osx"
brew_smart_install "switchaudio-osx"

echo "install sox"
brew_smart_install "sox"

invoke_tests "System" "Audio Device"
