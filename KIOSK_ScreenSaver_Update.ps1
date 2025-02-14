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

    Write-Output "Screensaver Updated..."

}


SetupSCR
