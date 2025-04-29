# Function to download and install Ivanti
Function InstallIvanti () {
    
    # Define the URL of the download file and the destination path
    $downloadUrl = "https://sacrpprdsculrsivanti01.blob.core.windows.net/ldshares3/IvantiEBA/KIOSK%20WIN%20Agent%202022_SU7.zip"
    $destinationPath = "C:\Windows\Temp\KIOSK_WIN_Agent_2022_SU7.zip"
    $extractPath = "C:\Windows\Temp\KIOSK_WIN_Agent_2022_SU7"

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
    $extractedFilePath = Join-Path $extractPath ('SelfContainedEpmAgentInstall.msi')
    Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$extractedFilePath`" /qn" -Wait -Verbose

    Write-Output "Waiting for Ivanti Agent install to complete...", ""
    Start-Sleep -Seconds 600

    Write-Output "Ivanti Agent install complete...", ""

}


# Run function to download and install Ivanti
InstallIvanti

