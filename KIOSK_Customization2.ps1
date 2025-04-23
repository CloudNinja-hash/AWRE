
param($Password)

# Converting parameter to secure string
$securePWD = ConvertTo-SecureString $Password -AsPlainText -Force

# Define the URL of the download file and the destination path
$downloadUrl = "https://dl.dropboxusercontent.com/scl/fi/7grf0rhauao2e0xiust40/Autologon64.exe?rlkey=v2i49l93acyuhlkp1t1fggrpl&st=vqs1m2u3"
$destinationPath = "C:\Windows\Temp\Autologon64.exe"

# Log file location for script
$logfilePath = "C:\LOG_Kiosk_Customization2.txt" 


## Start logging of script
Start-Transcript -Path "$logfilePath" -Append

# Running Ivanti scans
Write-Output "", "Running Ivanti Policy Sync...", ""
Start-Process -FilePath "C:\Program Files (x86)\Ivanti\EPM Agent\SWD\PolicySync.exe" -Wait

Write-Output "Running Ivanti Security Scan...", ""
Start-Process -FilePath "C:\Program Files (x86)\Ivanti\EPM Agent\Patch Management\vulscan.exe" -ArgumentList "/scan=3 /showui" -Wait

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

## End logging
Stop-Transcript | Out-Null
