#!/bin/bash -e -o pipefail

source $HOME/.bashrc
# Invoke-PesterTests throws on any test failure, so pwsh exits non-zero when a test fails.
# On success it returns normally, but a passing run can leave a non-zero $LASTEXITCODE behind
# from the last native command Pester executed (e.g. a "Should -ReturnZeroExitCode" check).
# Recent PowerShell builds surface that lingering $LASTEXITCODE as pwsh's own process exit
# code, which fails the Packer provisioner (exit 123) even though every test passed.
# Force a clean exit on success; the throw above already aborts before this on real failures.
pwsh -Command "Import-Module '$HOME/image-generation/tests/Helpers.psm1' -DisableNameChecking
        Invoke-PesterTests -TestFile \"$1\" -TestName \"$2\"
        exit 0"
