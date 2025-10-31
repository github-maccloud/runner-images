#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-nginx.sh
##  Desc:  Install Nginx
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

brew_smart_install nginx
sudo sed -Ei '' 's/listen.*/listen 80;/' $(brew --prefix)/etc/nginx/nginx.conf

invoke_tests "WebServers" "Nginx"
