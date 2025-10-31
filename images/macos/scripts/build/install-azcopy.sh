#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-azcopy.sh
##  Desc:  Install AzCopy
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

if is_Arm64; then
    url="https://aka.ms/downloadazcopy-v10-mac-arm64"
else
    url="https://aka.ms/downloadazcopy-v10-mac"
fi

# Install AzCopy
archive_path=$(download_with_retry ${url})
unzip -qq $archive_path -d /tmp/azcopy
extract_path=$(echo /tmp/azcopy/azcopy*)
cp $extract_path/azcopy /usr/local/bin/azcopy
chmod +x /usr/local/bin/azcopy


invoke_tests "Common" "AzCopy"
