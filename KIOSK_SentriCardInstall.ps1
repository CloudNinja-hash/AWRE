# Define the URL of the download file and the destination path
$downloadUrl = "https://dl.dropboxusercontent.com/scl/fi/ciyls30ld7lfqbqv47wm9/SentriCardUtilityInstaller-4.0.20.exe?rlkey=9qozcl9hdtndk6lgdrdl5nerq&st=y27p8lw7"
$destinationPath = "C:\Windows\Temp\SentriCardUtilityInstaller-4.0.20.exe"

# Define app location and desktop shortcut location
$sentriApp = "C:\Program Files (x86)\SentriCardUtility\CardUtility.exe"
$shortcutApp = "$env:Public\Desktop\Sentri Card Utility.lnk"

# Download the file
Write-Output "Downloading SentriCardUtilityInstaller-4.0.20.exe...", ""
Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -Verbose

# Change the password
Write-Output "Installing SentriCard App...", ""
Start-Process -FilePath $destinationPath -ArgumentList "/SILENT"

Start-Sleep -Seconds 15

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($shortcutApp)
$Shortcut.TargetPath = $sentriApp
$Shortcut.Save()


$downloadUrl = $null
$destinationPath = $null
$sentriApp = $null
$shortcutApp = $null
