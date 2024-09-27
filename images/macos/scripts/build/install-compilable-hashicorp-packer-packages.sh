#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-compilable-hashicorp-packer-packages.sh
##  Desc:  Install compilable hashicorp-packer packages
################################################################################

source ~/utils/utils.sh

brew install hashicorp/tap/packer

# invoke_tests "Common" "Compiled"
