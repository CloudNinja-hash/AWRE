# Requires running as Administrator
$mountPoint = "C:"

# 1. Check current status
$status = Get-BitLockerVolume -MountPoint $mountPoint

if ($status.EncryptionPercentage -gt 0) {
    Write-Output "Encryption is at $($status.EncryptionPercentage)%. Initiating decryption on $mountPoint..."
    
    # Start decryption process
    Disable-BitLocker -MountPoint $mountPoint
    
    # 2. Wait loop until decryption completes
    do {
        Start-Sleep -Seconds 10
        $status = Get-BitLockerVolume -MountPoint $mountPoint
        Write-Output "Decryption progress: $($status.EncryptionPercentage)% remaining..."
    } while ($status.EncryptionPercentage -gt 0 -or $status.VolumeStatus -eq 'Decrypting')

    Write-Output "Decryption complete! Rebooting device in 10 seconds..."
    Start-Sleep -Seconds 10
    
    # 3. Reboot the system
    Restart-Computer -Force
} else {
    Write-Output "Volume $mountPoint is already fully decrypted (0%). No action taken."
}
