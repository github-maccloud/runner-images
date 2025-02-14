#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-git.sh
##  Desc:  Install Git and Git LFS
################################################################################

source ~/utils/utils.sh

#echo "Installing Git..."
#brew_smart_install "git"

echo "Installing Git 2.47.1 from custom tap..."

# Use brew tap to reference the custom tap that contains Git 2.47.1 formula
brew tap my-tap-name /path/to/tap

# Install Git 2.47.1 from custom tap
brew install my-tap-name/git@2.47.1

# Verify that the correct version of Git is installed
git --version

git config --global --add safe.directory "*"

echo "Installing Git LFS"
brew_smart_install "git-lfs"

# Update global git config
git lfs install
# Update system git config
sudo git lfs install --system

echo "Disable all the Git help messages..."
git config --global advice.pushUpdateRejected false
git config --global advice.pushNonFFCurrent false
git config --global advice.pushNonFFMatching false
git config --global advice.pushAlreadyExists false
git config --global advice.pushFetchFirst false
git config --global advice.pushNeedsForce false
git config --global advice.statusHints false
git config --global advice.statusUoption false
git config --global advice.commitBeforeMerge false
git config --global advice.resolveConflict false
git config --global advice.implicitIdentity false
git config --global advice.detachedHead false
git config --global advice.amWorkDir false
git config --global advice.rmHints false

invoke_tests "Git"
