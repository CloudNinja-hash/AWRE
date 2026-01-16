
<#
.SYNOPSIS
  Removes all per-user Google Chrome installations across local user profiles.

.DESCRIPTION
  - Enumerates profiles under C:\Users (excludes special/system profiles).
  - For each profile, tries Chrome's per-user uninstaller; falls back to directory removal.
  - Optionally kills Chrome processes started from the per-user path.
  - Cleans per-user registry keys for Chrome (and optionally Google Update).
  - Cleans per-user shortcuts (Start Menu, Desktop).
  - Outputs a summary table.

.NOTES
  Run as Administrator. Supports -WhatIf and -Verbose.

.PARAMETER KillChrome
  Whether to kill Chrome processes originating from the per-user install paths. Default: $true.

.PARAMETER ScrubRegistry
  Remove per-user registry keys related to Chrome. Default: $true.

.PARAMETER RemoveUserGoogleUpdate
  Also remove per-user Google Update keys and folders. Default: $false.

.EXAMPLE
  .\Remove-PerUserChrome.ps1 -Verbose

.EXAMPLE
  .\Remove-PerUserChrome.ps1 -WhatIf
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [switch]$KillChrome = $true,
  [switch]$ScrubRegistry = $true,
  [switch]$RemoveUserGoogleUpdate = $false
)

function Get-LocalUserProfiles {
    Get-CimInstance Win32_UserProfile |
      Where-Object {
        $_.LocalPath -and
        $_.LocalPath -like 'C:\Users\*' -and
        -not $_.Special -and
        (Test-Path $_.LocalPath)
      } |
      Sort-Object LocalPath -Unique
}

function Invoke-ChromeUninstallOrRemove {
    param(
      [Parameter(Mandatory=$true)][string]$UserRoot,
      [switch]$KillChrome
    )
    $result = [ordered]@{
        User               = Split-Path $UserRoot -Leaf
        UserRoot           = $UserRoot
        Found              = $false
        UninstallAttempted = $false
        Uninstalled        = $false
        FolderRemoved      = $false
        ShortcutsRemoved   = $false
        RegistryCleaned    = $false
        Errors             = @()
    }

    $localAppData  = Join-Path $UserRoot 'AppData\Local'
    $roaming       = Join-Path $UserRoot 'AppData\Roaming'
    $chromeDir     = Join-Path $localAppData 'Google\Chrome'
    $chromeExe     = Join-Path $chromeDir 'Application\chrome.exe'
    $startMenuDir  = Join-Path $roaming 'Microsoft\Windows\Start Menu\Programs'
    $desktopDir    = Join-Path $UserRoot 'Desktop'

    $result.Found = Test-Path $chromeDir

    if (-not $result.Found) { return [pscustomobject]$result }

    # 1) Kill per-user Chrome processes from this path (optional)
    if ($KillChrome) {
        try {
            $pattern = ($chromeDir + '\*')
            Write-Verbose "Stopping chrome.exe processes under $pattern"
            Get-Process chrome -ErrorAction SilentlyContinue | Where-Object {
                $_.Path -and $_.Path -like "$pattern"
            } | Stop-Process -Force -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 500
        } catch {
            $result.Errors += "KillChrome: $($_.Exception.Message)"
        }
    }

    # 2) Try built-in per-user uninstall
    if (Test-Path $chromeExe) {
        try {
            $result.UninstallAttempted = $true
            if ($PSCmdlet.ShouldProcess($chromeExe, "Run --uninstall --force-uninstall")) {
                Write-Verbose "Attempting uninstall via $chromeExe --uninstall --force-uninstall"
                $p = Start-Process -FilePath $chromeExe `
                                   -ArgumentList @('--uninstall','--force-uninstall') `
                                   -PassThru -WindowStyle Hidden
                $p.WaitForExit()
                Start-Sleep -Milliseconds 500
            }
        } catch {
            $result.Errors += "Uninstall attempt: $($_.Exception.Message)"
        }
    }

    # 3) If still present, remove directory
    if (Test-Path $chromeDir) {
        try {
            if ($PSCmdlet.ShouldProcess($chromeDir, "Remove-Item -Recurse -Force")) {
                Write-Verbose "Removing directory $chromeDir"
                # Clear attributes & remove readonly locks
                Get-ChildItem -LiteralPath $chromeDir -Recurse -Force -ErrorAction SilentlyContinue |
                    ForEach-Object { $_.Attributes = 'Normal' } -ErrorAction SilentlyContinue
                Remove-Item -LiteralPath $chromeDir -Recurse -Force -ErrorAction Stop
            }
        } catch {
            $result.Errors += "Folder removal: $($_.Exception.Message)"
        }
    }

    $result.Uninstalled   = -not (Test-Path $chromeExe)
    $result.FolderRemoved = -not (Test-Path $chromeDir)

    # 4) Remove shortcuts (Start Menu + Desktop)
    try {
        $shortcuts = @(
            (Join-Path $startMenuDir 'Google Chrome.lnk'),
            (Join-Path $startMenuDir 'Chrome Apps'),
            (Join-Path $desktopDir   'Google Chrome.lnk')
        )
        foreach ($item in $shortcuts) {
            if (Test-Path $item) {
                if ($PSCmdlet.ShouldProcess($item, "Remove-Item -Recurse -Force")) {
                    Remove-Item -LiteralPath $item -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
        }
        $result.ShortcutsRemoved = $true
    } catch {
        $result.Errors += "Shortcut cleanup: $($_.Exception.Message)"
    }

    # 5) Clean per-user registry (HKCU for that profile) by loading hive if needed
    try {
        $profile = Get-CimInstance Win32_UserProfile | Where-Object { $_.LocalPath -eq $UserRoot }
        $sid = $profile.SID
        if (-not $sid) { throw "SID not found for $UserRoot" }

        $hkuPath = "Registry::HKEY_USERS\$sid"
        $hiveWasLoaded = $false

        if (-not (Test-Path $hkuPath)) {
            $ntuser = Join-Path $UserRoot 'NTUSER.DAT'
            if (Test-Path $ntuser) {
                Write-Verbose "Loading user hive HKU\$sid from $ntuser"
                & reg.exe load "HKU\$sid" "$ntuser" | Out-Null
                $hiveWasLoaded = $true
                Start-Sleep -Milliseconds 200
            }
        }

        if (Test-Path $hkuPath) {
            if ($ScrubRegistry) {
                $regTargets = @(
                    "$hkuPath\Software\Google\Chrome",
                    "$hkuPath\Software\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome"
                )
                if ($RemoveUserGoogleUpdate) {
                    $regTargets += "$hkuPath\Software\Google\Update"
                }
                foreach ($rk in $regTargets) {
                    if (Test-Path $rk) {
                        if ($PSCmdlet.ShouldProcess($rk, "Remove-Item -Recurse -Force")) {
                            Write-Verbose "Removing registry key $rk"
                            Remove-Item -Path $rk -Recurse -Force -ErrorAction SilentlyContinue
                        }
                    }
                }
                $result.RegistryCleaned = $true
            }
        }

        if ($hiveWasLoaded) {
            Write-Verbose "Unloading user hive HKU\$sid"
            & reg.exe unload "HKU\$sid" | Out-Null
        }
    } catch {
        $result.Errors += "Registry cleanup: $($_.Exception.Message)"
    }

    # 6) Optional: remove per-user Google Update folder
    if ($RemoveUserGoogleUpdate) {
        try {
            $updDir = Join-Path $localAppData 'Google\Update'
            if (Test-Path $updDir) {
                if ($PSCmdlet.ShouldProcess($updDir, "Remove-Item -Recurse -Force")) {
                    Write-Verbose "Removing per-user Google Update folder $updDir"
                    Remove-Item -LiteralPath $updDir -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
        } catch {
            $result.Errors += "Google Update folder: $($_.Exception.Message)"
        }
    }

    return [pscustomobject]$result
}

# MAIN
Write-Verbose "Enumerating local user profiles..."
$profiles = Get-LocalUserProfiles
if (-not $profiles) {
    Write-Warning "No eligible user profiles found under C:\Users."
    return
}

$allResults = foreach ($p in $profiles) {
    Invoke-ChromeUninstallOrRemove -UserRoot $p.LocalPath -KillChrome:$KillChrome
}

Write-Host ""
Write-Host "==== Per-User Chrome Removal Summary ====" -ForegroundColor Cyan

$allResults |
    Sort-Object User |
    Select-Object User, Found, UninstallAttempted, Uninstalled, FolderRemoved, RegistryCleaned,
                  @{N='ErrorsCount';E={($_.Errors | Where-Object {$_}) .Count}} |
    Format-Table -AutoSize

# Optional: emit detailed errors (if any)
$errs = $allResults | Where-Object { $_.Errors -and $_.Errors.Count -gt 0 }
if ($errs) {
    Write-Host "`nErrors encountered:" -ForegroundColor Yellow
    foreach ($r in $errs) {
        Write-Host "[$($r.User)] $($r.Errors -join '; ')" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nNo errors reported." -ForegroundColor Green
}
