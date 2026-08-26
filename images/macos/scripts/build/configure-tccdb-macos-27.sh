#!/bin/bash -e -o pipefail
################################################################################
##  File:  configure-tccdb-macos.sh
##  Desc:  Configure permissions to the TCC.db
################################################################################

source ~/utils/utils.sh

print_system_tccdb_structure

print_user_tccdb_structure

# /Library/Application\ Support/com.apple.TCC/TCC.db
systemValuesArray=(
    "'kTCCServiceAccessibility','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceAccessibility','/opt/hca/hosted-compute-agent',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,NULL,1592919552,NULL,NULL"
    "'kTCCServiceAccessibility','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321319,NULL,NULL"
    "'kTCCServiceAccessibility','/usr/bin/osascript',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321319,NULL,NULL"
    "'kTCCServiceAccessibility','/usr/libexec/sshd-keygen-wrapper',1,2,4,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'UNUSED',NULL,0,1644564233,NULL,NULL"
    "'kTCCServiceAccessibility','/usr/local/opt/runner/provisioner/provisioner',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,NULL,1592919552,NULL,NULL"
    "'kTCCServiceAccessibility','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321319,NULL,NULL"
    "'kTCCServiceAccessibility','com.apple.Terminal',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,NULL,'UNUSED',NULL,0,1591180502,NULL,NULL"
    "'kTCCServiceAccessibility','com.apple.dt.Xcode-Helper',0,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1551941368,NULL,NULL"
    "'kTCCServiceAppleEvents','/bin/bash',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1591532620,NULL,NULL"
    "'kTCCServiceAppleEvents','/opt/hca/hosted-compute-agent',1,2,3,1,NULL,NULL,0,'com.apple.finder',X'fade0c000000002c00000001000000060000000200000010636f6d2e6170706c652e66696e64657200000003',NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/local/opt/runner/provisioner/provisioner',1,2,3,1,NULL,NULL,0,'com.apple.finder',X'fade0c000000002c00000001000000060000000200000010636f6d2e6170706c652e66696e64657200000003',NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','com.apple.Terminal',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,NULL,'UNUSED',NULL,0,1591180502,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/bin/osascript',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1591532620,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/bin/osascript',1,2,0,1,NULL,NULL,0,'com.apple.Safari',NULL,NULL,1755087312,NULL,NULL"
    "'kTCCServiceAppleEvents','/bin/bash',1,2,0,1,NULL,NULL,0,'com.apple.Safari',NULL,NULL,1755087312,NULL,NULL"
    "'kTCCServiceAppleEvents','/opt/hca/hosted-compute-agent',1,2,0,1,NULL,NULL,0,'com.apple.Safari',NULL,NULL,1755087312,NULL,NULL"
    "'kTCCServiceBluetoothAlways','/opt/hca/hosted-compute-agent',1,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceBluetoothAlways','/usr/local/opt/runner/provisioner/provisioner',1,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceMicrophone','/opt/hca/hosted-compute-agent',1,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceMicrophone','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576661342,NULL,NULL"
    "'kTCCServiceMicrophone','/usr/local/opt/runner/provisioner/provisioner',1,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceMicrophone','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576661342,NULL,NULL"
    "'kTCCServicePostEvent','/Library/Application Support/Veertu/Anka/addons/ankarund',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1644565949,NULL,NULL"
    "'kTCCServicePostEvent','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321326,NULL,NULL"
    "'kTCCServicePostEvent','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321326,NULL,NULL"
    "'kTCCServiceScreenCapture','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1599831148,NULL,NULL"
    "'kTCCServiceScreenCapture','/opt/hca/hosted-compute-agent',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1687786159,NULL,NULL"
    "'kTCCServiceScreenCapture','/usr/local/opt/runner/provisioner/provisioner',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1687786159,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','/usr/libexec/sshd-keygen-wrapper',1,0,4,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'UNUSED',NULL,0,1639660695,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','com.apple.Terminal',0,2,4,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'UNUSED',NULL,0,1678990068,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','com.microsoft.wdav',0,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,0,1643970979,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','com.microsoft.wdav.epsext',0,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,0,1643970979,NULL,NULL"
    "'kTCCServiceSystemPolicyNetworkVolumes','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceSystemPolicyNetworkVolumes','com.apple.Terminal',0,2,4,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'UNUSED',NULL,0,1678990068,NULL,NULL"
)
for values in "${systemValuesArray[@]}"; do
    configure_system_tccdb "$values,NULL,NULL,'UNUSED',${values##*,}"
done

# $HOME/Library/Application\ Support/com.apple.TCC/TCC.db
userValuesArray=(
    "'kTCCServiceAccessibility','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceAccessibility','/usr/bin/osascript',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321319,NULL,NULL"
    "'kTCCServiceAccessibility','com.apple.Terminal',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,NULL,'UNUSED',NULL,0,1591180502,NULL,NULL"
    "'kTCCServiceAppleEvents','/Library/Application Support/Veertu/Anka/addons/ankarund',1,2,3,1,NULL,NULL,0,'com.apple.Terminal',X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,1655808179,NULL,NULL"
    "'kTCCServiceAppleEvents','/Library/Application Support/Veertu/Anka/addons/ankarund',1,2,3,1,NULL,NULL,0,'com.apple.finder',X'fade0c000000002c00000001000000060000000200000010636f6d2e6170706c652e66696e64657200000003',NULL,1629294900,NULL,NULL"
    "'kTCCServiceAppleEvents','/Library/Application Support/Veertu/Anka/addons/ankarund',1,2,3,1,NULL,NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',NULL,164456761,NULL,NULL"
    "'kTCCServiceAppleEvents','/bin/bash',1,2,0,1,NULL,NULL,0,'com.apple.finder',NULL,NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/bin/bash',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1591532620,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/bin/osascript',1,2,0,1,NULL,NULL,0,'com.apple.finder',NULL,NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/bin/osascript',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1591532620,NULL,NULL"
    "'kTCCServiceAppleEvents','/opt/hca/hosted-compute-agent',1,2,3,1,NULL,NULL,0,'com.apple.finder',X'fade0c000000002c00000001000000060000000200000010636f6d2e6170706c652e66696e64657200000003',NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/opt/hca/hosted-compute-agent',1,2,3,1,NULL,NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1574241374,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/libexec/sshd-keygen-wrapper',1,2,0,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'com.apple.finder',X'fade0c000000002c00000001000000060000000200000010636f6d2e6170706c652e66696e64657200000003',NULL,1591357685"
    "'kTCCServiceAppleEvents','/usr/libexec/sshd-keygen-wrapper',1,2,3,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',NULL,1644564201"
    "'kTCCServiceAppleEvents','/usr/libexec/sshd-keygen-wrapper',1,2,3,1,X'fade0c000000003c0000000100000006000000020000001d636f6d2e6170706c652e737368642d6b657967656e2d7772617070657200000000000003',NULL,0,'com.apple.Terminal',X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,1650386089"
    "'kTCCServiceAppleEvents','/usr/local/opt/runner/provisioner/provisioner',1,2,3,1,NULL,NULL,0,'com.apple.finder',X'fade0c000000002c00000001000000060000000200000010636f6d2e6170706c652e66696e64657200000003',NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/local/opt/runner/provisioner/provisioner',1,2,3,1,NULL,NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',NULL,1592919552,NULL,NULL"
    "'kTCCServiceAppleEvents','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,0,'com.apple.systemevents',NULL,NULL,1574241374,NULL,NULL"
    "'kTCCServiceAppleEvents','com.apple.Terminal',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',NULL,1591180478,NULL,NULL"
    "'kTCCServiceBluetoothAlways','/opt/hca/hosted-compute-agent',1,2,3,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceBluetoothAlways','/usr/local/opt/runner/provisioner/provisioner',1,2,3,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceMicrophone','/opt/hca/hosted-compute-agent',1,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceMicrophone','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576661342,NULL,NULL"
    "'kTCCServiceMicrophone','/usr/local/opt/runner/provisioner/provisioner',1,2,4,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1736467200,NULL,NULL"
    "'kTCCServiceMicrophone','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576661342,NULL,NULL"
    "'kTCCServiceMicrophone','com.apple.CoreSimulator.SimulatorTrampoline',0,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1576347152,NULL,NULL"
    "'kTCCServicePostEvent','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceScreenCapture','/opt/hca/hosted-compute-agent',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1687786159,NULL,NULL"
    "'kTCCServiceScreenCapture','/usr/local/opt/runner/provisioner/provisioner',1,2,4,1,NULL,NULL,0,'UNUSED',NULL,0,1687786159,NULL,NULL"
    "'kTCCServiceScreenCapture','/bin/bash',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceScreenCapture','/usr/bin/osascript',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1566321319,NULL,NULL"
    "'kTCCServiceScreenCapture','com.apple.Terminal',0,2,4,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'UNUSED',NULL,0,1678990068,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','/opt/hca/start_hca.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceSystemPolicyAllFiles','/usr/local/opt/runner/runprovisioner.sh',1,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,0,1583997993,NULL,NULL"
    "'kTCCServiceUbiquity','/System/Library/PrivateFrameworks/PhotoLibraryServices.framework/Versions/A/Support/photolibraryd',1,2,5,1,NULL,NULL,NULL,'UNUSED',NULL,0,1619461750,NULL,NULL"
    "'kTCCServiceUbiquity','com.apple.CloudDocs.MobileDocumentsFileProvider',0,2,0,1,X'fade0c000000004c0000000100000006000000020000002f636f6d2e6170706c652e436c6f7564446f63732e4d6f62696c65446f63756d656e747346696c6550726f76696465720000000003',NULL,NULL,'UNUSED',NULL,0,1570793290,NULL,NULL"
    "'kTCCServiceUbiquity','com.apple.PassKitCore',0,2,5,1,NULL,NULL,NULL,'UNUSED',NULL,0,1619516250,NULL,NULL"
    "'kTCCServiceUbiquity','com.apple.TextEdit',0,2,0,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465787445646974000000000003',NULL,NULL,'UNUSED',NULL,0,1566368356,NULL,NULL"
    "'kTCCServiceUbiquity','com.apple.mail',0,2,0,1,NULL,NULL,NULL,'UNUSED',NULL,NULL,1551941469,NULL,NULL"
)
for values in "${userValuesArray[@]}"; do
    configure_user_tccdb "$values,NULL,NULL,'UNUSED',${values##*,}"
done

# Pre-approve screen capture for the runner agent.
# Granting kTCCServiceScreenCapture above is not enough on macOS 15+: capturing
# the screen through a legacy API instead of ScreenCaptureKit's picker raises a
# recurring "<app> is requesting to bypass the system private window picker"
# alert, which takes focus and breaks headed UI tests. replayd tracks the
# reminder in its own approvals file, keyed by the *responsible* process - on a
# hosted runner that is the agent, whatever tool the job actually runs. Since
# the file is absent in the image and every job gets a fresh VM, the reminder is
# always overdue and the alert fires on the first capture of every job.
# A far-future date suppresses it; replayd expands this into its own dictionary
# form on first use and keeps the date.
approvalsPlist="$HOME/Library/Group Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist"
mkdir -p "$(dirname "$approvalsPlist")"
defaults write "$approvalsPlist" "/opt/hca/hosted-compute-agent" -date "3024-01-01 00:00:00 +0000"

# flush the preferences cache so the write is on disk; System.Tests.ps1 asserts
# the approval is there
killall cfprefsd 2>/dev/null || true
