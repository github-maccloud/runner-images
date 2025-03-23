################################################################################
##  File:  Update-XcodeSimulators.ps1
##  Desc:  Check available Xcode simulators and create missing ones
##         Warm up all simulators to avoid first run issues
################################################################################

$ErrorActionPreference = "Stop"

Import-Module "$env:HOME/image-generation/helpers/Common.Helpers.psm1"
Import-Module "$env:HOME/image-generation/helpers/Xcode.Helpers.psm1" -DisableNameChecking
Import-Module "$env:HOME/image-generation/software-report/SoftwareReport.Xcode.psm1" -DisableNameChecking

$os = Get-OSVersion

function Get-SimulatorStatus {
    param (
        [Parameter(Mandatory)]
        [string] $UDID
    )
    # Get all available devices
    [string]$rawDevicesInfo = Invoke-Expression "xcrun simctl list devices --json"
    $jsonDevicesInfo = ($rawDevicesInfo | ConvertFrom-Json).devices
    # Check if the device with UUID is in the list to find out its state
    foreach ($runtime in $jsonDevicesInfo.PSObject.Properties) {
        foreach ($device in $runtime.Value) {
            if ($device.udid -eq $UDID) {
                return $device.state
            }
        }
    }
    # If the device is not found, return "Not Found" without throwing an error
    return "Not Found"
}
function Invoke-SimulatorState {
    param (
        [Parameter(Mandatory)]
        [string] $UDID,

        [Parameter(Mandatory)]
        [ValidateSet("Booted", "Shutdown")]
        [string] $TargetState
    )

    switch ($TargetState) {
        "Booted" {
            while ((Get-SimulatorStatus -UDID $UDID) -ne "Booted") {
                Invoke-Expression "xcrun simctl boot $UDID" | Out-Null
                Start-Sleep -Seconds 10
            }
        }
        "Shutdown" {
            while ((Get-SimulatorStatus -UDID $UDID) -ne "Shutdown") {
                Invoke-Expression "xcrun simctl shutdown $UDID" | Out-Null
                Start-Sleep -Seconds 10
            }
        }
    }
}

function Initialize-Simulators {
    param(
        [string[]] $AllowedDevices = @("iPhone", "iPad", "Apple Vision")
    )
    $regex = "(?i)($($AllowedDevices -join '|'))"
    $deviceMap = Get-XcodeDeviceUDIDMap

    foreach ($udid in $deviceMap.Keys) {
        if ($deviceMap[$udid].Value -match $regex) {
            Write-Host "Warming up simulator: $($deviceMap[$udid].Value) [$($udid)]"
            if ($(Get-SimulatorStatus -UDID $udid) -eq "Not Found") {
                throw "Simulator with UDID $udid not found."
            }
            Invoke-SimulatorState -UDID $udid -TargetState "Booted"
            Invoke-Expression "xcrun simctl io $udid enumerate --poll" | Out-Null
            Invoke-SimulatorState -UDID $udid -TargetState "Shutdown"
        }
    }
}

function Test-SimulatorInstalled {
    param(
        [Parameter(Mandatory)]
        [string] $RuntimeId,
        [Parameter(Mandatory)]
        [string] $DeviceId,
        [Parameter(Mandatory)]
        [string] $SimulatorName,
        [Parameter(Mandatory)]
        [string] $XcodeVersion
    )

    $simctlPath = Get-XcodeToolPath -Version $XcodeVersion -ToolName "simctl"
    if (-not (Test-Path $simctlPath)) {
        Write-Host "Skip validating simulator '$SimulatorName [$RuntimeId]' because Xcode $XcodeVersion is not installed"
        return
    }

    $simulatorFullNameDebug = "$SimulatorName [$RuntimeId]"
    Write-Host "Checking Xcode simulator '$simulatorFullNameDebug' (Xcode $XcodeVersion)..."

    # Get all available devices
    [string]$rawDevicesInfo = Invoke-Expression "$simctlPath list devices --json"
    $jsonDevicesInfo = ($rawDevicesInfo | ConvertFrom-Json).devices

    # Checking if simulator already exists
    $existingSimulator = $jsonDevicesInfo.$RuntimeId | Where-Object { $_.deviceTypeIdentifier -eq  $DeviceId } | Select-Object -First 1

    if ($null -eq $existingSimulator) {
        Write-Host "Simulator '$simulatorFullNameDebug' is missed. Creating it..."
        Invoke-Expression "$simctlPath create '$SimulatorName' '$DeviceId' '$RuntimeId'"
    } elseif ($existingSimulator.name -ne $SimulatorName) {
        Write-Host "Simulator '$simulatorFullNameDebug' is named incorrectly. Renaming it from '$($existingSimulator.name)' to '$SimulatorName'..."
        Invoke-Expression "$simctlPath rename '$($existingSimulator.udid)' '$SimulatorName'"
    } else {
        Write-Host "Simulator '$simulatorFullNameDebug' is installed correctly."
    }
}

# First run doesn't provide full data about devices
Get-XcodeInfoList | Out-Null

Write-Host "Validating and fixing Xcode simulators..."
Get-BrokenXcodeSimulatorsList | ForEach-Object {
    Test-SimulatorInstalled -RuntimeId $_.RuntimeId -DeviceId $_.DeviceId -SimulatorName $_.SimulatorName -XcodeVersion $_.XcodeVersion
}

if (-not $os.IsVentura) {
    Write-Host "Warming up all simulators..."
    Initialize-Simulators
}
