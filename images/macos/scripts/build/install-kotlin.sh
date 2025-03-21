#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-kotlin.sh
##  Desc:  Install kotlin
################################################################################

source ~/utils/utils.sh

echo Installing Kotlin
kotlinVersionToolset=$(get_toolset_value '.kotlin.version')
brew_smart_install "kotlin@${kotlinVersionToolset}"

echo Verifying Kotlin installation
kotlinc -version

invoke_tests "Kotlin"
