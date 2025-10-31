#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-node.sh
##  Desc:  Install Node.js
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

defaultVersion=$(get_toolset_value '.node.default')

echo "Installing Node.js $defaultVersion"
brew_smart_install "node@$defaultVersion"
brew link node@$defaultVersion --force --overwrite

echo Installing yarn...
yarn_installer_path=$(download_with_retry "https://yarnpkg.com/install.sh")
bash $yarn_installer_path

invoke_tests "Node" "Node.js"
