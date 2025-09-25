# Get the current logged-in user
$user = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Username

Write-Output "Current Logged-In User: $user"

# Create the user object and translate it to the SID
$objUser = New-Object System.Security.Principal.NTAccount($user)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])

Write-Output "Current Logged-In User SID: $strSID"

# Define the registry path
$registryPath = "registry::hkey_users\$($strSID.Value)\Software\Microsoft\Windows\CurrentVersion\PushNotifications"

# Create a key to disable toast notification
Set-ItemProperty -Path $registryPath -Name "ToastEnabled" -Value 0 -Type DWord -Force

$user = ""
$objUser = ""
$strSID = ""
$registryPath = ""
