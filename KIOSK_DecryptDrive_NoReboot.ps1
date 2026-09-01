# Requires running as Administrator
$mountPoint = "C:"

# 1. Check current status
$status = Get-BitLockerVolume -MountPoint $mountPoint

if ($status.VolumeStatus -ne 'FullyDecrypted') {
    Write-Output "Initiating BitLocker decryption on $mountPoint..."
    
    # Start decryption process
    Disable-BitLocker -MountPoint $mountPoint
    
    # 2. Wait loop until decryption completes fully
    do {
        Start-Sleep -Seconds 10
        $status = Get-BitLockerVolume -MountPoint $mountPoint
        Write-Output "Decryption progress: $($status.EncryptionPercentage)% remaining..."
    } while ($status.EncryptionPercentage -gt 0 -or $status.VolumeStatus -eq 'Decrypting')

    Write-Output "Decryption complete! Volume $mountPoint is fully decrypted and ready."
} else {
    Write-Output "Volume $mountPoint is already fully decrypted. No action taken."
}