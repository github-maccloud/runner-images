#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-rosetta.sh
##  Desc:  Install Rosetta
################################################################################

source ~/utils/utils.sh

echo "Installing Rosetta"
/usr/sbin/softwareupdate --install-rosetta --agree-to-license
track_component_size "rosetta"
