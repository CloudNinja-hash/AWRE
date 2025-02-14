
$CBDeskURL = 'https://realogy.okta.com'


$pathChrome = 'C:\Users\Public\Desktop\Chrome.lnk'

$pathEdge = 'C:\Users\Public\Desktop\Edge.lnk'


$testChrome = Test-Path -Path $pathChrome -PathType Leaf

$testEdge = Test-Path -Path $pathEdge -PathType Leaf


$shell = New-Object -ComObject WScript.Shell


Function CreateChrome () {

    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk' -Destination $pathChrome -Force

    Start-Sleep 5

    $ShortcutToChange = Get-ChildItem -Path $pathChrome -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $CBDeskURL
    
    $url.Save()

}


Function CreateEdge () {

    Copy-Item -Path 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk' -Destination $pathEdge -Force

    Start-Sleep 5

    $ShortcutToChange = Get-ChildItem -Path $pathEdge -ErrorAction SilentlyContinue

    $url = $shell.CreateShortcut($ShortcutToChange.FullName)
    
    $url.Arguments = $CBDeskURL
    
    $url.Save()

}


# Function to setup Restart Button on the desktop
Function SetupRestart () {

    # Define the URL of the download file and the destination path
    $downloadUrl = "https://www.dropbox.com/scl/fi/9fp62uwu7uych6yqv8k8g/RebootButton.zip?rlkey=tzesfdfpivpv85aco9ppm1wy7&st=adbu9gwq&dl=1"
    $destinationPath = "C:\Windows\Temp\RebootButton.zip"
    $extractPath = "C:\SCR\RestartButton"
    $verifyFile = "C:\SCR\RestartButton\Restart Button.lnk"
    $verifyDesktop = "C:\Users\Public\Desktop\Restart Button.lnk"

    # Verify "Restart Button.lnk" file exists, download files if it does not exist
    Write-Output "Verifying Restart Button.lnk exists...", ""
    if (Test-Path -Path $verifyFile -Verbose) {

        Write-Output "Restart Button.lnk exists...", ""

    } else {
        
        # Download the file
        Write-Output "Restart Button.lnk does not exist, downloading Restart Button files...", ""
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

    }


    # Verify "Restart Button.lnk" file exists on Public Desktop, copy files if it does not exist
    Write-Output "Verifying Restart Button.lnk exists on Public Desktop...", ""
    if (Test-Path -Path $verifyDesktop -Verbose) {

        Write-Output "Restart Button.lnk exists on Public Desktop...", ""

    } else {
        
        # Copy the shortcut to Public Desktop
        Write-Output "Restart Button.lnk does not exist on Public Desktop, copying Restart Button files...", ""
        
        # Copy the Restart Button.lnk file to the desktop
        Copy-Item -Path "C:\SCR\RestartButton\Restart Button.lnk" -Destination "C:\Users\Public\Desktop" -Force -Verbose
        Write-Output "File copied successfully to C:\Users\Public\Desktop"

    } 

}


<##
## If Chrome does not exist, create it.
if (-not($testChrome)) {
    
    Write-Output "Chrome shortcut NOT found, creating shortcut...", ""

    CreateChrome

}
else {

    Write-Output "Cannot create $pathChrome because file already exists...", ""

}


## If Edge does not exist, create it.
if (-not($testEdge)) {
    
    Write-Output  "Edge shortcut NOT found, creating shortcut...", ""

    CreateEdge

}
else {

    Write-Output "Cannot create $pathEdge because file already exists...", ""

}
##>

CreateChrome
CreateEdge
SetupRestart
