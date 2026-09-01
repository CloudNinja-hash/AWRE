# Requires running as Administrator
$mountPoint = "C:"

# 1. Check current BitLocker status
$status = Get-BitLockerVolume -MountPoint $mountPoint

# Check if protection is enabled or active
if ($status.ProtectionStatus -eq 'On') {
    Write-Output "BitLocker protection is ON for $mountPoint. Suspending BitLocker..."
    
    # 2. Suspend BitLocker protection indefinitely (RebootCount 0)
    Suspend-BitLocker -MountPoint $mountPoint -RebootCount 0
    
    # Re-verify protection status
    $updatedStatus = Get-BitLockerVolume -MountPoint $mountPoint
    Write-Output "BitLocker status is now: $($updatedStatus.ProtectionStatus). Drive is ready for deployment."
} else {
    Write-Output "BitLocker protection on $mountPoint is already OFF or Suspended ($($status.ProtectionStatus)). No action taken."
}