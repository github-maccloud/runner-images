Import-Module "$PSScriptRoot/../helpers/Common.Helpers.psm1"

$os = Get-OSVersion

Describe "Git" {
    It "git is installed" {
        "git --version" | Should -ReturnZeroExitCode
    }
    It "git lfs is installed" {
        "git lfs version" | Should -ReturnZeroExitCode
    }
    It "git credential helper is disabled" {
        (Get-CommandResult "git config --get credential.helper").Output | Should -BeNullOrEmpty
    }
}
