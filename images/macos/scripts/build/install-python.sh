#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-python.sh
##  Desc:  Install Python
################################################################################

source ~/utils/utils.sh

echo "Installing Python Tooling"

# Close Finder window
close_finder_window

echo "Brew Installing Python 3"
brew_smart_install "python@3.12"

echo "Installing pipx"

# Use standard pipx environment path regardless of architecture
export PIPX_BIN_DIR="$HOME/.local/bin"
export PIPX_HOME="$HOME/.local/pipx"

brew_smart_install "pipx"

echo "export PIPX_BIN_DIR=${PIPX_BIN_DIR}" >> "${HOME}/.bashrc"
echo "export PIPX_HOME=${PIPX_HOME}" >> "${HOME}/.bashrc"
echo 'export PATH="$PIPX_BIN_DIR:$PATH"' >> "${HOME}/.bashrc"

invoke_tests "Python"
