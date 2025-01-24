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
    if (Test-Path $directory) {

        # Get all files and directories in the specified path
        $items = Get-ChildItem -Path $directory

        # Loop through each item and remove it
        foreach ($item in $items) {
        
            Remove-Item -Path $item.FullName -Recurse -Force
        
        }

        Write-Output "All contents in $directory have been deleted."
    
    } else {
    
        Write-Output "The directory $directory does not exist."
    
    }

}

# Function to create Chrome desktop shortcut
Function CreateChrome () {

    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk' -Destination $pathChrome -Force

    Start-Sleep 5

    $ShortcutToChange = Get-ChildItem -Path $pathChrome -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $HomepageURL
    
    $url.Save()

}

# Function to create Edge desktop shortcut
Function CreateEdge () {

    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk' -Destination $pathEdge -Force

    Start-Sleep 5

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
    if (Test-Path $path) {

        Write-Output "The directory $path exists."
    
    } else {
    
        Write-Output "The directory $path does not exist. Creating the directory..."
    
        New-Item -Path $path -ItemType Directory -Force
    
        Write-Output "The directory $path has been created."
    
    }

}

# Function to Clear Browser cache on close for Edge/Chrome
Function ClearBrowser () {

    New-Item -Path "HKLM:\SOFTWARE\Policies\Google" -Force -ErrorAction SilentlyContinue
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force -ErrorAction SilentlyContinue
    New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Force -ErrorAction SilentlyContinue

    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "SkipFirstRunUI" -PropertyType DWord -Value "1" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "1" -PropertyType String -Value "browsing_history" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "2" -PropertyType String -Value "download_history" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "3" -PropertyType String -Value "cookies_and_other_site_data" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "4" -PropertyType String -Value "cached_images_and_files" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "5" -PropertyType String -Value "password_signin" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "6" -PropertyType String -Value "autofill" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "7" -PropertyType String -Value "site_settings" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Name "8" -PropertyType String -Value "hosted_app_data" -Force -ErrorAction SilentlyContinue

    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force -ErrorAction SilentlyContinue

    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HideFirstRunExperience" -PropertyType DWord -Value "1" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "ClearBrowsingDataOnExit" -PropertyType DWord -Value "0x00000001" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "AutofillAddressEnabled" -PropertyType DWord -Value "0x00000000" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "AutofillCreditCardEnabled" -PropertyType DWord -Value "0x00000000" -Force -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HideFirstRunExperience" -PropertyType DWord -Value "0x00000000" -Force -ErrorAction SilentlyContinue

}

# Run function to create C:\SCR if it does not exist
CreateSCRdir

# Run function to delete existing shortcuts from Public Desktop
ClearDesktop

# Run function to create Chrome/Edge desktop shortcuts
CreateChrome
CreateEdge

# Run function to Clear Browser cache on close for Edge/Chrome
ClearBrowser

# Disable the power button
powercfg -attributes SUB_BUTTONS PBUTTONACTION -ATTRIB_HIDE
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 0
powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 0

# Set the screen to go to sleep after 30 minutes
powercfg -change -monitor-timeout-ac 30
powercfg -change -monitor-timeout-dc 30

# Ensure the computer stays on all the time
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0

# Remove the sleep option from the Start menu
powercfg -attributes SUB_SLEEP STANDBYIDLE -ATTRIB_HIDE
powercfg -attributes SUB_SLEEP STANDBYIDLE -ATTRIB_HIDE

# Apply the changes
powercfg -setactive SCHEME_CURRENT

# Hide Sleep and Shutdown options from the Start menu
$registryPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideSleep"
New-ItemProperty -Path $registryPath -Name "Value" -Value 1 -PropertyType DWord -Force

$registryPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown"
New-ItemProperty -Path $registryPath -Name "Value" -Value 1 -PropertyType DWord -Force

# Disable Fast Startup
$registryPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Start\HideShutDown"
Set-ItemProperty -Path $registryPath -Name "HiberbootEnabled" -Value 0 -Type DWORD -Force

# Refresh the Start menu to apply changes
Stop-Process -Name explorer -Force
Start-Process explorer

# Set the password to never expire
Set-LocalUser -Name "Agent" -PasswordNeverExpires 1 -UserMayChangePassword 0

<#
# Prevent the user from changing the password
$User = ADSI
$User.UserFlags = $User.UserFlags -bor 0x10000
$User.SetInfo()
#>