################################################################################
##  File:  Configure-Xcode-Simulators.ps1
##  Team:  CI-Build
##  Desc:  Check and remove duplicate simulators
##         Warm up all simulators to avoid first run issues
################################################################################

Import-Module "~/image-generation/helpers/Common.Helpers.psm1"
Import-Module "~/image-generation/helpers/Xcode.Helpers.psm1"

$os = Get-OSVersion

function Initialize-Simulators {
    param(
        [string[]] $AllowedDevices = @("iPhone", "iPad", "Apple Vision")
    )

    $regex = "(?i)($($AllowedDevices -join '|'))"
    $deviceMap = Get-XcodeDeviceUDIDMap

    foreach ($udid in $deviceMap.Keys) {
        if ($deviceMap[$udid] -match $regex) {
            Write-Host "Warming up simulator: $($deviceMap[$udid]) [$($udid)]"
            if ($(Get-SimulatorStatus -UDID $udid) -eq "Not Found") {
                throw "Simulator with UDID $udid not found."
            }
            Invoke-SimulatorState -UDID $udid -TargetState "Booted"
            # Wait for the simulator to be fully booted
            Start-Sleep -Seconds 60
            Invoke-SimulatorState -UDID $udid -TargetState "Shutdown"
        }
    }
}

# Make object of all simulators
$devicesList = $(xcrun simctl list -j devices | ConvertFrom-Json)
$devicesObject = [System.Collections.ArrayList]@()
foreach ($runtime in $devicesList.devices.psobject.Properties.name) {
    foreach ($device in $devicesList.devices.$runtime) {
        $devicesObject += [PSCustomObject]@{
            runtime = $runtime
            DeviceName = $($device.name)
            DeviceId = $($device.udid)
            DeviceCreationTime = (Get-Item $HOME/Library/Developer/CoreSimulator/Devices/$($device.udid)).CreationTime
        }
    }
}

# Remove duplicates
foreach ($simRuntume in $devicesObject.runtime | Sort-Object -Unique) {
    [System.Collections.ArrayList]$sameRuntimeDevices = [array]$($devicesObject | Where-Object {$_.runtime -eq $simRuntume} | Sort-Object -Property DeviceName)
    Write-Host "///////////////////////////////////////////////////////////////////"
    Write-Host "// Checking for duplicates in $simRuntume "
    $devicesAsHashTable =  $sameRuntimeDevices | Group-Object -Property DeviceName -AsHashTable -AsString
    foreach ($key in $devicesAsHashTable.Keys) {
        if ( $devicesAsHashTable[$key].count -gt 1) {
            Write-Host "// Duplicates for $key - $($devicesAsHashTable[$key].count)"
        }
    }
    Write-Host "///////////////////////////////////////////////////////////////////"
    for ($i = 0; $i -lt $sameRuntimeDevices.Count; $i++) {
        if ( [string]::IsNullOrEmpty($($sameRuntimeDevices[$i+1].DeviceName)) ){
            Write-Host "No more devices to compare in $simRuntume"
            Write-Host "-------------------------------------------------------------------"
            continue
        }
        Write-Host "$($sameRuntimeDevices[$i].DeviceName) - DeviceId $($sameRuntimeDevices[$i].DeviceId) comparing with"
        Write-Host "$($sameRuntimeDevices[$i+1].DeviceName) - DeviceId $($sameRuntimeDevices[$i+1].DeviceId)"
        Write-Host "-------------------------------------------------------------------"
        if ($sameRuntimeDevices[$i].DeviceName -eq $sameRuntimeDevices[$i+1].DeviceName) {
            Write-Host "*******************************************************************"
            Write-Host "** Duplicate found"
            if ($sameRuntimeDevices[$i].DeviceCreationTime -lt $sameRuntimeDevices[$i+1].DeviceCreationTime) {
                Write-Host "** will be removed $($sameRuntimeDevices[$i+1].DeviceName) with id $($sameRuntimeDevices[$i+1].DeviceId)"
                xcrun simctl delete $sameRuntimeDevices[$i+1].DeviceId
                $sameRuntimeDevices.RemoveAt($i+1)
            } else {
                Write-Host "** will be removed $($sameRuntimeDevices[$i].DeviceName) with id $($sameRuntimeDevices[$i].DeviceId)"
                xcrun simctl delete $sameRuntimeDevices[$i].DeviceId
                $sameRuntimeDevices.RemoveAt($i)
            }
            Write-Host "*******************************************************************"
        }
    }
}

# Warm up all simulators to avoid first run issues
if (-not $os.IsVentura) {
    Write-Host "Warming up all simulators..."
    Initialize-Simulators
}
