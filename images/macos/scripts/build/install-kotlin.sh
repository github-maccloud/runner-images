#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-kotlin.sh
##  Desc:  Install kotlin
################################################################################


echo "Installing Kotlin 2.1.10"

# Specify the commit hash where Kotlin 2.1.10 was available in Homebrew
COMMIT=442af88a2925f8c0e079eaf4fa62261133d2d7c4
FORMULA_URL="https://raw.githubusercontent.com/Homebrew/homebrew-core/$COMMIT/Formula/k/kotlin.rb"
FORMULA_PATH="$(brew --repository)/Library/Taps/homebrew/homebrew-core/Formula/k/kotlin.rb"

# Create the necessary directory
mkdir -p "$(dirname $FORMULA_PATH)"

# Download the specific Kotlin 2.1.10 formula
curl -fsSL $FORMULA_URL -o $FORMULA_PATH

# Install Kotlin 2.1.10 without updating Homebrew or using the API
HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew install "$FORMULA_PATH"

# Verify installation
kotlinc -version

invoke_tests "Kotlin"
