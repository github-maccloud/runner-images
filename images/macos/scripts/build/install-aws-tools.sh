#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-aws-tools.sh
##  Desc:  Install the AWS CLI, Session Manager plugin for the AWS CLI, and AWS SAM CLI
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

echo "Installing aws..."
awscliv2_pkg_path=$(download_with_retry "https://awscli.amazonaws.com/AWSCLIV2.pkg")
sudo installer -pkg "$awscliv2_pkg_path" -target /

echo "Installing aws sam cli..."
brew tap aws/tap
brew_smart_install aws-sam-cli

echo "Install aws cli session manager"
brew install --cask session-manager-plugin

invoke_tests "Common" "AWS"
