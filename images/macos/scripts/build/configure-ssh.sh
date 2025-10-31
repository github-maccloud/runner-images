#!/bin/bash -e -o pipefail
################################################################################
##  File:  configure-ssh.sh
##  Desc:  Configure ssh
################################################################################
# DEBUG: view iana timezone version
echo "/usr/share"

echo "/usr/share/zoneinfo/+VERSION"
cat /usr/share/zoneinfo/+VERSION
echo "/usr/share/zoneinfo"
ls -la /usr/share/zoneinfo
echo "/var/db/timezone"
ls -la /var/db/timezone

[[ ! -d ~/.ssh ]] && mkdir ~/.ssh 2>/dev/null
chmod 777 ~/.ssh

ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts
ssh-keyscan -t rsa ssh.dev.azure.com >> ~/.ssh/known_hosts
