#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-kotlin.sh
##  Desc:  Install kotlin
################################################################################

source ~/utils/utils.sh

echo Installing Kotlin
kotlinVersionToolset=$(get_toolset_value '.kotlin.version')
#brew_smart_install "kotlin@${kotlinVersionToolset}"

brew uninstall kotlin || true
brew extract --version=${kotlinVersionToolset} kotlin homebrew/cask-versions
brew install ./kotlin@${kotlinVersionToolset}.rb
brew link --force kotlin@${kotlinVersionToolset}

echo Verifying Kotlin installation
kotlinc -version

invoke_tests "Kotlin"
