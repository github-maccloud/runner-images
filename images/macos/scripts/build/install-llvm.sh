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

llvmVersion=$(get_toolset_value '.llvm.version')

brew_smart_install "llvm@${llvmVersion}"

echo "which clang:   $(which clang)"
echo "which clang++: $(which clang++)"
clang --version
clang++ --version

invoke_tests "LLVM"
