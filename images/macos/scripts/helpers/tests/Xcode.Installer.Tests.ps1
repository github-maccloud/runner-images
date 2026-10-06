################################################################################
##  File:  Xcode.Installer.Tests.ps1
##  Desc:  Unit tests for simulator runtime installation and cache preparation
################################################################################

BeforeAll {
    Import-Module "$PSScriptRoot/../Xcode.Installer.psm1" -Force -DisableNameChecking
}

Describe "Wait-SimulatorRuntimeCache" {
    BeforeEach {
        $script:now = [DateTime]::new(2026, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)
        $script:checks = 0
        $script:worker = "/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/update_dyld_sim_shared_cache"
        Mock Get-Date -ModuleName Xcode.Installer { $script:now }
        Mock Start-Sleep -ModuleName Xcode.Installer {
            $script:now = $script:now.AddSeconds($Seconds)
        }
        Mock ps -ModuleName Xcode.Installer {
            $global:LASTEXITCODE = 0
            "/usr/sbin/other-process"
        }
    }

    It "returns immediately when no cache worker is running" {
        Wait-SimulatorRuntimeCache

        Should -Invoke ps -ModuleName Xcode.Installer -Times 1 -Exactly
        Should -Invoke Start-Sleep -ModuleName Xcode.Installer -Times 0 -Exactly
    }

    It "waits until the last cache worker finishes" {
        Mock ps -ModuleName Xcode.Installer {
            $global:LASTEXITCODE = 0
            $script:checks++
            if ($script:checks -eq 1) { $script:worker; $script:worker }
            if ($script:checks -eq 2) { $script:worker }
        }

        Wait-SimulatorRuntimeCache

        Should -Invoke ps -ModuleName Xcode.Installer -Times 3 -Exactly
        Should -Invoke Start-Sleep -ModuleName Xcode.Installer -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
    }

    It "fails after ten minutes rather than waiting indefinitely" {
        Mock ps -ModuleName Xcode.Installer {
            $global:LASTEXITCODE = 0
            $script:worker
        }

        { Wait-SimulatorRuntimeCache } | Should -Throw "*exceeded ten minutes*"

        Should -Invoke Start-Sleep -ModuleName Xcode.Installer -Times 40 -Exactly -ParameterFilter { $Seconds -eq 15 }
    }

    It "does not treat a failed process check as readiness" {
        Mock ps -ModuleName Xcode.Installer { $global:LASTEXITCODE = 1 }

        { Wait-SimulatorRuntimeCache } | Should -Throw "*Unable to check*"

        Should -Invoke Start-Sleep -ModuleName Xcode.Installer -Times 0 -Exactly
    }
}

Describe "Install-XcodeAdditionalSimulatorRuntimes" {
    BeforeEach {
        $script:events = [System.Collections.Generic.List[string]]::new()
        Mock Invoke-ValidateCommand -ModuleName Xcode.Installer { $script:events.Add($Command.Trim()) }
        Mock Wait-SimulatorRuntimeCache -ModuleName Xcode.Installer { $script:events.Add("wait") }
    }

    It "waits after downloading all platforms and preserves architecture arguments" {
        Install-XcodeAdditionalSimulatorRuntimes -Version "26.2" -Arch "arm64" -Runtimes "default"

        ($script:events -join "|") | Should -Be "/Applications/Xcode_26.2.app/Contents/Developer/usr/bin/xcodebuild -downloadAllPlatforms -architectureVariant universal|wait"
    }

    It "waits after a default platform download" {
        Install-XcodeAdditionalSimulatorRuntimes -Version "16.4" -Arch "arm64" -Runtimes @{
            iOS = @("default"); watchOS = @("skip"); tvOS = @("skip"); visionOS = @("skip")
        }

        ($script:events -join "|") | Should -Be "/Applications/Xcode_16.4.app/Contents/Developer/usr/bin/xcodebuild -downloadPlatform iOS|wait"
    }

    It "waits between explicit runtime versions and after the final download" {
        Install-XcodeAdditionalSimulatorRuntimes -Version "16.4" -Arch "arm64" -Runtimes @{
            iOS = @("18.5", "18.6"); watchOS = @("skip"); tvOS = @("skip"); visionOS = @("skip")
        }

        $command = "/Applications/Xcode_16.4.app/Contents/Developer/usr/bin/xcodebuild -downloadPlatform iOS -buildVersion"
        ($script:events -join "|") | Should -Be "$command 18.5|wait|$command 18.6|wait"
    }

    It "does not download or wait for skipped runtimes" -ForEach @(
        @{ Runtimes = "none" }
        @{ Runtimes = @{ iOS = @("skip"); watchOS = @("skip"); tvOS = @("skip"); visionOS = @("skip") } }
    ) {
        Install-XcodeAdditionalSimulatorRuntimes -Version "16.4" -Arch "arm64" -Runtimes $Runtimes

        $script:events.Count | Should -Be 0
    }

    It "preserves installation errors without waiting or starting another download" -ForEach @(
        @{ Runtimes = "default" }
        @{ Runtimes = @{ iOS = @("default") } }
        @{ Runtimes = @{ iOS = @("18.5", "18.6") } }
    ) {
        Mock Invoke-ValidateCommand -ModuleName Xcode.Installer { throw "installation failed" }

        { Install-XcodeAdditionalSimulatorRuntimes -Version "16.4" -Arch "arm64" -Runtimes $Runtimes } |
            Should -Throw "*installation failed*"

        Should -Invoke Invoke-ValidateCommand -ModuleName Xcode.Installer -Times 1 -Exactly
        Should -Invoke Wait-SimulatorRuntimeCache -ModuleName Xcode.Installer -Times 0 -Exactly
    }

    It "does not start the next download when the wait fails" {
        Mock Wait-SimulatorRuntimeCache -ModuleName Xcode.Installer { throw "cache preparation timed out" }

        { Install-XcodeAdditionalSimulatorRuntimes -Version "16.4" -Arch "arm64" -Runtimes @{ iOS = @("18.5", "18.6") } } |
            Should -Throw "*cache preparation timed out*"

        Should -Invoke Invoke-ValidateCommand -ModuleName Xcode.Installer -Times 1 -Exactly
    }
}
