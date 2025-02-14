# Function to download and uninstall EPM Agent
Function UninstallIvanti () {
    
    # Define the URL of the download file and the destination path
    $downloadUrl = "https://sacrpprdsculrsivanti01.blob.core.windows.net/ldshares3/IvantiEBA/UninstallWinClient.exe"
    $destinationPath = "C:\Windows\Temp\UninstallWinClient.exe"

    # Download the file
    Write-Output "Downloading Ivanti EPM Uninstaller...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -Verbose

    # Start the process with the downloaded file
    Write-Output "Uninstalling Ivanti EPM Agent...", ""
    Start-Process -FilePath $destinationPath -ArgumentList "/FORCECLEAN /NOREBOOT" -Wait -Verbose

    Write-Output "Waiting for Ivanti EPM Agent uninstall to complete...", ""
    Start-Sleep -Seconds 300

    Write-Output "Ivanti EPM Agent uninstall complete...", ""

}


# Run function to download and uninstall Ivanti EPM
UninstallIvanti
