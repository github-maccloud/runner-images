#!/bin/bash -e -o pipefail
################################################################################
##  File:  configure-machine.sh
##  Desc:  Configure guest OS settings
################################################################################

source ~/utils/utils.sh

echo "Enabling developer mode..."
sudo /usr/sbin/DevToolsSecurity --enable

# Turn off hibernation and get rid of the sleepimage
sudo pmset hibernatemode 0
sudo rm -f /var/vm/sleepimage

# Disable App Nap System Wide
defaults write NSGlobalDomain NSAppSleepDisabled -bool YES

# Disable Keyboard Setup Assistant window
sudo defaults write /Library/Preferences/com.apple.keyboardtype "keyboardtype" -dict-add "3-7582-0" -int 40

# Detect macOS version
DARWIN_VERSION=$(uname -r | cut -d '.' -f1)

# Check if SIP is disabled
if csrutil status | grep -Eq "System Integrity Protection status: (disabled|unknown)"; then
    sudo bash -c 'echo -n "a" > /private/var/db/Accessibility/.VoiceOverAppleScriptEnabled'
    
    # macOS 15 (Darwin 24) requires updating the new plist location
    if [ "$DARWIN_VERSION" -eq 24 ]; then
        PLIST_PATH="$HOME/Library/Group Containers/group.com.apple.VoiceOver/Library/Preferences/com.apple.VoiceOver4/default.plist"

        if [ -f "$PLIST_PATH" ]; then
            sudo plutil -replace SCREnableAppleScript -bool true "$PLIST_PATH"
            echo "✅ VoiceOver AppleScript control enabled for macOS 15."
        else
            echo "⚠️ Warning: Plist file not found at $PLIST_PATH"
        fi
    else
        # Use old method for macOS versions before 15
        defaults write com.apple.VoiceOver4/default SCREnableAppleScript -bool YES
    fi
else
    echo "❌ SIP is enabled. Please disable SIP before running this script."
fi

# https://developer.apple.com/support/expiration/
swiftc -suppress-warnings "${HOME}/image-generation/add-certificate.swift"

certs=(
    AppleWWDRCAG3.cer
    DeveloperIDG2CA.cer
)
for cert in ${certs[@]}; do
    echo "Adding ${cert} certificate"
    cert_path="${HOME}/${cert}"
    curl -fsSL "https://www.apple.com/certificateauthority/${cert}" --output ${cert_path}
    sudo ./add-certificate ${cert_path}
    rm ${cert_path}
done

rm -f ./add-certificate

# enable-automationmode-without-authentication
brew install expect
retry=10
while [[ $retry -gt 0 ]]; do
{
    /usr/bin/expect <<EOF
        spawn automationmodetool enable-automationmode-without-authentication
        expect "password"
        send "${PASSWORD}\r"
        expect {
            "succeeded." { puts "Automation mode enabled successfully"; exit 0 }
            eof
        }
EOF
} && break

    retry=$((retry-1))
    if [[ $retry -eq 0 ]]; then
        echo "No retry attempts left"
        exit 1
    fi
    sleep 10
done

echo "Getting terminal windows"
launchctl_output=$(launchctl list | grep -i terminal || true)

if [ -n "$launchctl_output" ]; then
    term_service=$(echo "$launchctl_output" | cut -f3)
    echo "Close terminal windows: gui/501/${term_service}"
    launchctl bootout gui/501/${term_service} && sleep 5
else
    echo "No open terminal windows found."
fi

# test enable-automationmode-without-authentication
if [[ ! "$(automationmodetool)" =~ "DOES NOT REQUIRE" ]]; then
    echo "Failed to enable enable-automationmode-without-authentication option"
    exit 1
fi

# Fix sudoers file permissions
sudo chmod 440 /etc/sudoers.d/*

# Add NOPASSWD for the current user to sudoers
sudo sed -i '' 's/%admin\t\tALL = (ALL) ALL/%admin\t\tALL = (ALL) NOPASSWD: ALL/g' /etc/sudoers

# Create symlink for tests running
if [[ ! -d "/usr/local/bin" ]];then
    sudo mkdir -p -m 775 /usr/local/bin
    sudo chown $USER:admin /usr/local/bin
fi
chmod +x $HOME/utils/invoke-tests.sh
sudo ln -s $HOME/utils/invoke-tests.sh /usr/local/bin/invoke_tests
