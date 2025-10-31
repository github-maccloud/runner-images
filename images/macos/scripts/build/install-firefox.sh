#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-firefox.sh
##  Desc:  Install firefox browser
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

echo "Installing Firefox..."
brew install --cask firefox

echo "Installing Geckodriver..."
brew_smart_install "geckodriver"
geckoPath="$(brew --prefix geckodriver)/bin"

echo "Add GECKOWEBDRIVER to bashrc..."
echo "export GECKOWEBDRIVER=${geckoPath}" >> ${HOME}/.bashrc

invoke_tests "Browsers" "Firefox"
