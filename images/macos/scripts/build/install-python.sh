#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-python.sh
##  Desc:  Install Python
################################################################################

source ~/utils/utils.sh

echo "Installing Python Tooling"

# Close Finder window
close_finder_window

if is_SonomaX64; then
    # For the MacOS 14 Intel python dependency expat stopped to work, using pinned commit
    COMMIT=808c33c0f058f5898ef0556a343a5599f801f942
    FILE_NAME="e/expat.rb"
    FORMULA_NAME="expat"
    brew_install_pinned_formula "$FORMULA_NAME" "$FILE_NAME" "$COMMIT"
fi

# Installing latest Homebrew Python 3 to handle python3 and pip3 symlinks
if is_Arm64; then
    echo "Brew Installing default Python 3"
    brew_smart_install "python3"
else
    echo "Brew Installing pinned Python 3.15.0_1"

    COMMIT=014cba5977d8d903d2e006e063e74808b877898c
    FILE_NAME="p/python@3.15.rb"
    FORMULA_NAME="python@3.15"
    brew_install_pinned_formula "$FORMULA_NAME" "$FILE_NAME" "$COMMIT"
fi;

# Pipx has its own Python dependency
echo "Installing pipx"

if is_Arm64; then
    export PIPX_BIN_DIR="$HOME/.local/bin"
    export PIPX_HOME="$HOME/.local/pipx"
else
    export PIPX_BIN_DIR=/usr/local/opt/pipx_bin
    export PIPX_HOME=/usr/local/opt/pipx
fi

brew_smart_install "pipx"

echo "export PIPX_BIN_DIR=${PIPX_BIN_DIR}" >> ${HOME}/.bashrc
echo "export PIPX_HOME=${PIPX_HOME}" >> ${HOME}/.bashrc
echo 'export PATH="$PIPX_BIN_DIR:$PATH"' >> ${HOME}/.bashrc

invoke_tests "Python"
