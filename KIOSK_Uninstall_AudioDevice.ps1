# Define the device name to search for
$deviceName = "Synaptics HD Audio"

# Get all PnP devices and filter by the device name
$device = Get-PnpDevice | Where-Object { $_.FriendlyName -like "$deviceName" }

# If the device is found, get its hardware ID
if ( $device ) {
    $deviceID = $device.InstanceId
    $hardwareIDs = Get-PnpDeviceProperty -InstanceId $deviceID -KeyName 'DEVPKEY_Device_HardwareIds'
    $driverINFPath = Get-PnpDeviceProperty -InstanceId $deviceID -KeyName 'DEVPKEY_Device_DriverInfPath'

    $hardwareDatas = $hardwareIDs.Data
    $driverINFs = $driverINFPath.Data

    Write-Output "","Device ID: $deviceID"
    Write-Output "Deleting Audio Device..."

    pnputil.exe /remove-device "$deviceID" /force

    foreach ( $driverINF in $driverINFs ) {

        Write-Output "", "Drive INF: $driverINF"
        Write-Output "Deleting Drivers..."

        pnputil.exe /delete-driver "$driverINF" /uninstall /force

    }


} else {

    Write-Output "Device '$deviceName' not found."

}

Start-Sleep -Seconds 10

Restart-Computer -Force
