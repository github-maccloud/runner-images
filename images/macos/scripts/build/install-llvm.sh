#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-llvm.sh
##  Desc:  Install LLVM
################################################################################

source ~/utils/utils.sh

echo "which clang:   $(which clang)"
echo "which clang++: $(which clang++)"
clang --version
clang++ --version

brew_smart_install "https://raw.githubusercontent.com/Homebrew/homebrew-core/b23c39cd600bd312ecbfcec262c5c8ef059b0607/Formula/l/llvm%4018.rb"

echo "which clang:   $(which clang)"
echo "which clang++: $(which clang++)"
clang --version
clang++ --version

invoke_tests "LLVM"
