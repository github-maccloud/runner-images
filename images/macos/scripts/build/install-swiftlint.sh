#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-swiftlint.sh
##  Desc:  Install SwiftLint 0.58.2
################################################################################

source ~/utils/utils.sh

echo "Installing SwiftLint 0.58.2..."

# Pin SwiftLint to 0.58.2 due to issues with newer versions
# https://github.com/Homebrew/homebrew-core/pull/204527
swiftlint_commit="f46d29944b415df9f1eedad85e4fde41a948c7c0"
swiftlint_rb_link="https://raw.githubusercontent.com/Homebrew/homebrew-core/$swiftlint_commit/Formula/s/swiftlint.rb"
swiftlint_rb_path=$(download_with_retry "$swiftlint_rb_link")

brew install "$swiftlint_rb_path"

# Run the test hook
invoke_tests "Linters" "SwiftLint"
