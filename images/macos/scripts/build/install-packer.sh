#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-bicep.sh
##  Desc:  Install bicep cli
################################################################################

source ~/utils/utils.sh

echo "Installing packer..."
brew tap hashicorp/tap
brew_smart_install hashicorp/tap/packer

invoke_tests "Common" "Packer"

