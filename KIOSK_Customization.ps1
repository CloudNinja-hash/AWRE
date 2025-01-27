# Log file location for script
$logfilePath = "C:\LOG_Kiosk_Customization.txt" 

# Variables for creating desktop shortcuts for Edge/Chrome
$HomepageURL = 'https://mycbdesk.com'
$pathChrome = 'C:\Users\Public\Desktop\Chrome.lnk'
$pathEdge = 'C:\Users\Public\Desktop\Edge.lnk'
$shell = New-Object -ComObject WScript.Shell

# Function to delete existing shortcuts from Public Desktop
Function ClearDesktop () {

    # Get the path to the directory
    $directory = 'C:\Users\Public\Desktop'

    # Check if the directory exists
    Write-Output "Verify $directory exists...", ""
    if (Test-Path $directory -Verbose) {
        
        Write-Output "The directory $directory exists...", ""

        # Get all files and directories in the specified path
        $items = Get-ChildItem -Path $directory

        # Loop through each item and remove it
        Write-Output "Deleting existing Desktop Shortcuts in $directory...", ""
        foreach ($item in $items) {
        
            Remove-Item -Path $item.FullName -Recurse -Force -Verbose
        
        }

        Write-Output "All contents in $directory was deleted...", ""
    
    } else {
    
        Write-Output "The directory $directory does not exist...", ""
    
    }

    if (Test-Path "C:\Users\Agent\Desktop\Google Chrome.lnk") {

        Write-Output "C:\Users\Agent\Desktop\Google Chrome.lnk exists...", ""

        Remove-Item -Path "C:\Users\Agent\Desktop\Google Chrome.lnk" -Force -Verbose

        Write-Output "C:\Users\Agent\Desktop\Google Chrome.lnk was deleted...", ""

    } else {

        Write-Output "C:\Users\Agent\Desktop\Google Chrome.lnk does not exist...", ""
        
    }

}

# Function to create Chrome desktop shortcut
Function CreateChrome () {
    
    Write-Output "Creating Chrome Desktop shortcut...", ""
    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk' -Destination $pathChrome -Force -Verbose

    Start-Sleep -Seconds 5

    $ShortcutToChange = Get-ChildItem -Path $pathChrome -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $HomepageURL
    
    $url.Save()

}

# Function to create Edge desktop shortcut
Function CreateEdge () {
    
    Write-Output "Creating Edge Desktop shortcut...", ""
    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk' -Destination $pathEdge -Force -Verbose

    Start-Sleep -Seconds 5

    $ShortcutToChange = Get-ChildItem -Path $pathEdge -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $HomepageURL
    
    $url.Save()

}

# Function to create C:\SCR if it does not exist
Function CreateSCRdir () {

    # Define the path to check
    $path = "C:\SCR"

    # Check if the path exists
    Write-Output "Verify $path exists...", ""
    if (Test-Path $path -Verbose) {

        Write-Output "The directory $path exists..."
    
    } else {
    
        Write-Output "The directory $path does not exist. Creating the directory..."
    
        New-Item -Path $path -ItemType Directory -Force
    
        Write-Output "The directory $path was been created..."
    
    }

}

# Function to Clear Browser cache on close for Edge/Chrome
Function ClearBrowser () {
    
    Write-Output "Creating registry path for Chrome settings...", ""
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google" -Force -ErrorAction SilentlyContinue -Verbose
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force -ErrorAction SilentlyContinue -Verbose
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Force -ErrorAction SilentlyContinue -Verbose

    Write-Output "Creating keys to Clear Browser Cache on close for Chrome...", ""
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "SkipFirstRunUI" -PropertyType DWord -Value "1" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "PromotionalTabsEnabled" -PropertyType DWord -Value "0" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "DefaultBrowserSettingEnabled" -PropertyType DWord -Value "0" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "1" -PropertyType String -Value "browsing_history" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "2" -PropertyType String -Value "download_history" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "3" -PropertyType String -Value "cookies_and_other_site_data" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "4" -PropertyType String -Value "cached_images_and_files" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "5" -PropertyType String -Value "password_signin" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "6" -PropertyType String -Value "autofill" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "7" -PropertyType String -Value "site_settings" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "8" -PropertyType String -Value "hosted_app_data" -Force -ErrorAction SilentlyContinue -Verbose

    New-Item -Path 'C:\Users\Agent\AppData\Local\Google\Chrome\User Data\First Run' -ItemType File -Force -Verbose

    Write-Output "Creating registry path for Edge settings...", ""
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force -ErrorAction SilentlyContinue -Verbose

    Write-Output "Creating keys to Clear Browser Cache on close for Edge...", ""
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HideFirstRunExperience" -PropertyType DWord -Value "1" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "ClearBrowsingDataOnExit" -PropertyType DWord -Value "0x00000001" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "AutofillAddressEnabled" -PropertyType DWord -Value "0x00000000" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "AutofillCreditCardEnabled" -PropertyType DWord -Value "0x00000000" -Force -ErrorAction SilentlyContinue -Verbose
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HideFirstRunExperience" -PropertyType DWord -Value "0x00000001" -Force -ErrorAction SilentlyContinue -Verbose

}

# Function to hide Recycle Bin on the desktop
Function HideRecycleBin () {

    # Define the registry path for the Recycle Bin icon for all users
    $regPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

    # Define the registry key for the Recycle Bin
    $regKey = "{645FF040-5081-101B-9F08-00AA002F954E}"

    # Set the value to 1 to hide the Recycle Bin icon for all users
    Write-Output "Hiding Recycle Bin from the Desktop...", ""
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force -Verbose

}


# Function to download and install Ivanti
Function InstallIvanti () {
    
    # Define the URL of the download file and the destination path
    $downloadUrl = "https://www.dropbox.com/scl/fi/v873cxvki3fn3vg2mz9jx/KIOSK_WIN_Agent_2022_SU6.zip?rlkey=wu9d7e6pfvq8z852c837mdcvl&st=xc8xfjdq&dl=1"
    $destinationPath = "C:\Windows\Temp\KIOSK_WIN_Agent_2022_SU6.zip"
    $extractPath = "C:\Windows\Temp\KIOSK_WIN_Agent_2022_SU6"

    # Download the file
    Write-Output "Downloading Ivanti Agent installer...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -Verbose

    # Create the extraction directory if it doesn't exist
    Write-Output "Verify extraction directory exist...", ""
    if (Test-Path -Path $extractPath -Verbose) {
        
        Write-Output "Extraction directory exists...", ""

    } else {
        
        Write-Output "Extraction directory does not exist, creating $extractPath directory...", ""
        New-Item -ItemType Directory -Path $extractPath -Verbose

    }

    # Extract the ZIP file
    Write-Output "Extracting Ivanti Agent installer to $extractPath...", ""
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($destinationPath, $extractPath)

    # Start the process with the extracted file
    Write-Output "Installing Ivanti Agent...", ""
    $extractedFilePath = Join-Path $extractPath ('KIOSK_WIN_Agent_2022_SU6.msi')
    Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$extractedFilePath`" /quiet /norestart" -Wait -Verbose

    Write-Output "Waiting for Ivanti Agent install to complete...", ""
    Start-Sleep -Seconds 300

    Write-Output "Ivanti Agent install complete...", ""

}

# Function to download and install PrinterLogic
Function InstallPrinter () {

    # Define the URL of the download file and the destination path
    $downloadUrl = "https://www.dropbox.com/scl/fi/iamz14ca5yiwptuqtj2rn/PrinterInstallerClient25001125.zip?rlkey=2aszgaej5a7ots0ejsavnqzfy&st=j6zpfsde&dl=1"
    $destinationPath = "C:\Windows\Temp\PrinterInstallerClient25001125.zip"
    $extractPath = "C:\Windows\Temp\PrinterInstallerClient25001125"

    # Download the file
    Write-Output "Downloading PrinterLogic installer...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    # Create the extraction directory if it doesn't exist
    Write-Output "Verify extraction directory exist...", ""
    if (Test-Path -Path $extractPath -Verbose) {
        
        Write-Output "Extraction directory exists...", ""

    } else {

        Write-Output "Extraction directory does not exist, creating $extractPath directory...", ""
        New-Item -ItemType Directory -Path $extractPath

    }

    # Extract the ZIP file
    Write-Output "Extracting PrinterLogic installer to $extractPath...", ""
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($destinationPath, $extractPath)

    # Start the process with the extracted file
    Write-Output "Installing PrinterLogic...", ""
    $extractedFilePath = Join-Path $extractPath ('PrinterInstallerClient25001125.msi')
    Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$extractedFilePath`" /quiet /norestart HOMEURL=https://realogy.printercloud.com AUTHORIZATION_CODE=991h51hz" -Wait -Verbose

    Write-Output "Waiting for PrinterLogic install to complete...", ""
    Start-Sleep -Seconds 30

    Write-Output "PrinterLogic install complete...", ""

}

# Function to setup screensaver
Function SetupSCR () {
    
    # Define the URL of the download file and the destination path
    $downloadUrl = "https://www.dropbox.com/scl/fi/dnwlw2pmwfykqp0dt048j/ScreenSaver.sCr?rlkey=2iisz8xhvmcufwdozfe5fx3du&st=e1i4rf0v&dl=1"
    $destinationPath = "C:\Windows\Temp\ScreenSaver.scr"

    # Download the file
    Write-Output "Downloading AWRE Screensaver...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    # Copy the file
    Copy-Item -Path $destinationPath -Destination "C:\SCR\screensaver.scr" -Force -Verbose
    Write-Output "File copied successfully to C:\SCR\screensaver.scr..."

    # Get the current logged-in user
    $user = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Username

    Write-Output "Current Logged-In User: $user"

    # Create the user object and translate it to the SID
    $objUser = New-Object System.Security.Principal.NTAccount($user)
    $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])

    Write-Output "Current Logged-In User SID: $strSID"
    
    New-Item -Path "registry::hkey_users\$($strSID.Value)\Software\Policies\Microsoft\Windows\Control Panel" -Force -ErrorAction SilentlyContinue -Verbose
    New-Item -Path "registry::hkey_users\$($strSID.Value)\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -Force -ErrorAction SilentlyContinue -Verbose

    # Define registry path using current logged-in user's SID
    $registryPath = "registry::hkey_users\$($strSID.Value)\Software\Policies\Microsoft\Windows\Control Panel\Desktop"

    # Enable screensaver
    New-ItemProperty -Path $registryPath -Name ScreenSaveActive -PropertyType String -Value 1 -Force -ErrorAction SilentlyContinue -Verbose

    # Set the screensaver to C:\SCR\screensaver.scr
    New-ItemProperty -Path $registryPath -Name SCRNSAVE.EXE -PropertyType String -Value 'C:\SCR\screensaver.scr' -Force -ErrorAction SilentlyContinue -Verbose
        
    # Set screensaver timeout to 15 minutes (900 seconds)
    New-ItemProperty -Path $registryPath -Name ScreenSaveTimeOut -PropertyType String -Value 900 -Force -ErrorAction SilentlyContinue -Verbose

    # Disable password requirement on resume
    New-ItemProperty -Path $registryPath -Name ScreenSaverIsSecure -PropertyType String -Value 0 -Force -ErrorAction SilentlyContinue -Verbose

    Write-Output "Screensaver settings updated for all users."

}

# Function to setup Restart Button on the desktop
Function SetupRestart () {

    # Define the URL of the download file and the destination path
    $downloadUrl = "https://www.dropbox.com/scl/fi/9fp62uwu7uych6yqv8k8g/RebootButton.zip?rlkey=tzesfdfpivpv85aco9ppm1wy7&st=adbu9gwq&dl=1"
    $destinationPath = "C:\Windows\Temp\RebootButton.zip"
    $extractPath = "C:\SCR\RestartButton"

    # Download the file
    Write-Output "Downloading Restart Button files...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    # Create the extraction directory if it doesn't exist
    Write-Output "Verify extraction directory exist...", ""
    if (Test-Path -Path $extractPath -Verbose) {
        
        Write-Output "Extraction directory exists...", ""

    } else {

        Write-Output "Extraction directory does not exist, creating $extractPath directory...", ""
        New-Item -ItemType Directory -Path $extractPath -Force -Verbose

    }

    # Extract the ZIP file
    Write-Output "Extracting Restart Button files to $extractPath...", ""
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($destinationPath, $extractPath)

    # Copy the file
    Copy-Item -Path "C:\SCR\RestartButton\Restart Button.lnk" -Destination "C:\Users\Public\Desktop" -Force -Verbose
    Write-Output "File copied successfully to C:\Users\Public\Desktop"

}

# Function to Setup Autologin
Function SetupAutologin () {

    # Define the URL of the download file and the destination path
    $downloadUrl = "https://download.sysinternals.com/files/AutoLogon.zip"
    $destinationPath = "C:\Windows\Temp\AutoLogon.zip"
    $extractPath = "C:\SCR\AutoLogon"

    # Download the file
    Write-Output "Downloading Autologin files...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath

    # Create the extraction directory if it doesn't exist
    Write-Output "Verify extraction directory exist...", ""
    if (Test-Path -Path $extractPath -Verbose) {
        
        Write-Output "Extraction directory exists...", ""

    } else {

        Write-Output "Extraction directory does not exist, creating $extractPath directory...", ""
        New-Item -ItemType Directory -Path $extractPath -Force -Verbose

    }

    # Extract the ZIP file
    Write-Output "Extracting Autologin files to $extractPath...", ""
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($destinationPath, $extractPath)

    Write-Output "Setting up Autologin...."
    
    try {

        Start-Process "C:\scr\Autologon\Autologon64.exe" -ArgumentList "Agent","WorkGroup","@g3ntW0rkst@ti0n","/accepteula" -Wait -Verbose
    
        Write-Output "Autologin setup complete..."

    } catch {

        Write-Output "Autologin setup failed, please review logs..."

    }

}

## Start logging of script
Start-Transcript -Path "$logfilePath" -Append

# Run function to download and install Ivanti
InstallIvanti

# Run function to download and install PrinterLogic
InstallPrinter

# Run function to hide Recycle Bin on the desktop
HideRecycleBin

# Run function to create C:\SCR if it does not exist
CreateSCRdir

# Run function to delete existing shortcuts from Public Desktop
ClearDesktop

# Run function to setup screensaver
SetupSCR

# Run function to setup Restart Button on the desktop
SetupRestart

# Run function to create Chrome/Edge desktop shortcuts
CreateChrome
CreateEdge

# Run function to Clear Browser cache on close for Edge/Chrome
ClearBrowser

# Disable the power button
Write-Output "Disabling the Power Button...", ""
powercfg -attributes SUB_BUTTONS PBUTTONACTION -ATTRIB_HIDE
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 0

# Set the screen to go to sleep after 30 minutes
Write-Output "Set the screen to go to sleep after 30 minutes...", ""
powercfg -change -monitor-timeout-ac 30
powercfg -change -monitor-timeout-dc 30

# Ensure the computer stays on all the time
Write-Output "Ensure the computer stays on all the time...", ""
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0

# Remove the sleep option from the Start menu
Write-Output "Remove the sleep option from the Start menu...", ""
powercfg -attributes SUB_SLEEP STANDBYIDLE -ATTRIB_HIDE
powercfg -attributes SUB_SLEEP STANDBYIDLE -ATTRIB_HIDE

# Apply the changes
Write-Output "Apply the above changes...", ""
powercfg -setactive SCHEME_CURRENT

# Hide Sleep and Shutdown options from the Start menu
Write-Output "Hide Sleep and Shutdown options from the Start menu...", ""
$registryPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideSleep"
New-ItemProperty -Path $registryPath -Name "Value" -Value 1 -PropertyType DWord -Force -Verbose

$registryPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown"
New-ItemProperty -Path $registryPath -Name "Value" -Value 1 -PropertyType DWord -Force -Verbose

# Disable Fast Startup
Write-Output "Disable Fast Startup...", ""
$registryPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown"
Set-ItemProperty -Path $registryPath -Name "HiberbootEnabled" -Value 0 -Type DWORD -Force -Verbose

# Refresh the Start menu to apply changes
Write-Output "Refresh the Start menu to apply changes...", ""
Stop-Process -Name explorer -Force -Verbose
Start-Process explorer -Verbose

# Run function to Setup Autologin
SetupAutologin

# Set the password to never expire
Write-Output "Set the password to never expire...", ""
Get-LocalUser -Name "Agent" | Set-LocalUser -PasswordNeverExpires $true -Verbose

## End logging
Stop-Transcript | Out-Null
