
param($Password)

# Converting parameter to secure string
$securePWD = ConvertTo-SecureString $Password -AsPlainText -Force

# Define the URL of the download file and the destination path
$downloadUrl = "https://dl.dropboxusercontent.com/scl/fi/7grf0rhauao2e0xiust40/Autologon64.exe?rlkey=v2i49l93acyuhlkp1t1fggrpl&st=vqs1m2u3"
$destinationPath = "C:\Windows\Temp\Autologon64.exe"

# Log file location for script
$logfilePath = "C:\LOG_Kiosk_Customization2.txt" 

function Disable-ToastNotification () {

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

}


## Start logging of script
Start-Transcript -Path "$logfilePath" -Append

# Launch Chrome for the first time to clear the Adobe Reader pop-up
Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" "https://okta.anywhere.re"

# Run function to disable toast notification
Disable-ToastNotification

# Download the file
Write-Output "Downloading Autologon64.exe...", ""
Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -Verbose

# Get the Agent account
Write-Output "Getting Agent account info...", ""
$localAcct = Get-LocalUser -Name "Agent"

# Change the password
Write-Output "Changing Agent password...", ""
$localAcct | Set-LocalUser -Password $securePWD -AccountNeverExpires -PasswordNeverExpires $true -Verbose

Start-Sleep -Seconds 60

Write-Output "Updating Autologon settings...", ""
Start-Process -FilePath $destinationPath -ArgumentList "/accepteula","Agent","WorkGroup",$Password

$downloadUrl = $null
$destinationPath = $null
$securePWD = $null
$Password = $null

# Close Chrome that was opened earlier
Stop-Process -Name chrome -Force

Start-Sleep -Seconds 3

Restart-Computer -Force

## End logging
Stop-Transcript | Out-Null
