#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-rubygems.sh
##  Desc:  Install RubyGems
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

echo "Updating RubyGems..."
gem update --system

# Temporarily install activesupport 7.2.2.1 due to compatibility issues with cocoapods https://github.com/CocoaPods/CocoaPods/issues/12081
gem install activesupport -v 7.2.2.1

gemsToInstall=$(get_toolset_value '.ruby.rubygems | .[]')
if [[ -n $gemsToInstall ]]; then
    for gem in $gemsToInstall; do
        echo "Installing gem $gem"
        gem install $gem
    done
fi

invoke_tests "RubyGem"
