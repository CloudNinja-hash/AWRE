# Function to download and install Ivanti
Function InstallIvanti () {
    
    # Define the URL of the download file and the destination path
    $downloadUrl = "https://dl.dropboxusercontent.com/scl/fi/lp57jpn0aqswrz815im71/KIOSK-WIN-Agent-2024_SU3.zip?rlkey=eguln78d92u8of6ig1wj9qhcp&st=08k5mcgl=1"
    $destinationPath = "C:\Windows\Temp\KIOSK_WIN_Agent_2024_SU3.zip"
    $extractPath = "C:\Windows\Temp\KIOSK_WIN_Agent_2024_SU3"

    # Download the file
    Write-Output "Downloading Ivanti Agent installer...", ""
    Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath -Verbose

    # Create the extraction directory if it doesn't exist
    Write-Output "Verify extraction directory exists...", ""
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

# Run the function to download and install Ivanti
InstallIvanti
