#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-php.sh
##  Desc:  Install PHP
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

echo Installing PHP
phpVersionToolset=$(get_toolset_value '.php.version')
brew_smart_install "php@${phpVersionToolset}"

echo Installing composer
brew_smart_install "composer"

invoke_tests "PHP"
