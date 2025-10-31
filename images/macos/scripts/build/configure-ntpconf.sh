#!/bin/bash -e -o pipefail
################################################################################
##  File:  configure-ntpconf.sh
##  Desc:  Configure NTP servers and set the timezone to UTC
################################################################################
# DEBUG: view iana timezone version
echo "/usr/share"

echo "/usr/share/zoneinfo/+VERSION"
cat /usr/share/zoneinfo/+VERSION
echo "/usr/share/zoneinfo"
ls -la /usr/share/zoneinfo
echo "/var/db/timezone"
ls -la /var/db/timezone

echo Additional NTP servers adding into /etc/ntp.conf file...
cat > /etc/ntp.conf << EOF
server 0.pool.ntp.org
server 1.pool.ntp.org
server 2.pool.ntp.org
server 3.pool.ntp.org
server time.apple.com
server time.windows.com
EOF

# Set the timezone to UTC.
echo "The Timezone setting to UTC..."
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
