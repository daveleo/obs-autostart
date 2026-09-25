# Expromo OBS Autostart - setup helper.
# Run through Install.cmd, Pause OBS.cmd, Resume OBS.cmd or Uninstall.cmd.
# Guide: https://daveleo.github.io/obs-autostart/

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('install', 'pause', 'resume', 'uninstall')]
    [string]$Action
)

$ErrorActionPreference = 'Stop'

$TaskName = 'OBS Appliance Watchdog'
$Root     = Join-Path $env:LOCALAPPDATA 'OBS-Appliance'
$Watchdog = Join-Path $Root 'obs-watchdog.ps1'
$StopFile = Join-Path $Root 'STOP'
$ObsExe   = 'C:\Program Files\obs-studio\bin\64bit\obs64.exe'
$User     = [Security.Principal.WindowsIdentity]::GetCurrent().Name

function Say([string]$Text, [string]$Color = 'Gray') {
    Write-Host $Text -ForegroundColor $Color
}

function Close-Obs {
    $obs = Get-Process -Name 'obs64' -ErrorAction SilentlyContinue
    if (-not $obs) { return }

    Say 'Closing OBS...'
    # Polite close (no /F), same as choosing Exit in OBS.
    cmd.exe /c 'taskkill /IM obs64.exe >nul 2>&1'
    $obs | Wait-Process -Timeout 20 -ErrorAction SilentlyContinue

    if (Get-Process -Name 'obs64' -ErrorAction SilentlyContinue) {
        Say 'OBS is still open. Close it yourself: right-click the OBS icon next to the clock and choose Exit.' Yellow
    }
}

switch ($Action) {

    'install' {
        if (-not (Test-Path $ObsExe)) {
            Say "OBS Studio was not found at:`n  $ObsExe" Red
            Say 'Install OBS Studio with the standard installer (default folder) and run Install again.' Red
            exit 1
        }

        New-Item -ItemType Directory -Path $Root -Force | Out-Null
        Copy-Item -Path (Join-Path $PSScriptRoot 'obs-watchdog.ps1') -Destination $Watchdog -Force
        Unblock-File -Path $Watchdog
        Remove-Item -Path $StopFile -Force -ErrorAction SilentlyContinue

        $taskAction = New-ScheduledTaskAction `
            -Execute "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" `
            -Argument "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$Watchdog`"" `
            -WorkingDirectory $Root
        $trigger   = New-ScheduledTaskTrigger -AtLogOn -User $User
        $principal = New-ScheduledTaskPrincipal -UserId $User -LogonType Interactive
        $settings  = New-ScheduledTaskSettingsSet `
            -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
            -ExecutionTimeLimit ([TimeSpan]::Zero) `
            -MultipleInstances IgnoreNew `
            -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) `
            -StartWhenAvailable

        Register-ScheduledTask -TaskName $TaskName `
            -Description 'Keeps OBS Studio running and performs unattended recovery.' `
            -Action $taskAction -Trigger $trigger -Principal $principal -Settings $settings `
            -Force | Out-Null

        Start-ScheduledTask -TaskName $TaskName

        Say ''
        Say "Installed for user $User." Green
        Say 'OBS will open in about 20 seconds, and from now on every time this user signs in.' Green
    }

    'pause' {
        New-Item -ItemType Directory -Path $Root -Force | Out-Null
        New-Item -ItemType File -Path $StopFile -Force | Out-Null
        Close-Obs
        Say ''
        Say 'Paused. OBS will NOT be restarted - not even after a reboot - until you run Resume OBS.' Yellow
    }

    'resume' {
        if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
            Say 'OBS Autostart is not installed on this user. Run Install.cmd first.' Red
            exit 1
        }
        Remove-Item -Path $StopFile -Force -ErrorAction SilentlyContinue
        # A watchdog that is still running simply carries on now the STOP file is gone.
        if ((Get-ScheduledTask -TaskName $TaskName).State -ne 'Running') {
            Start-ScheduledTask -TaskName $TaskName
        }
        Say ''
        Say 'Resumed. OBS will open in about 20 seconds (or keeps running if it is already open).' Green
    }

    'uninstall' {
        New-Item -ItemType Directory -Path $Root -Force | Out-Null
        New-Item -ItemType File -Path $StopFile -Force | Out-Null
        if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
            Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
            Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        }
        Remove-Item -Path $Root -Recurse -Force -ErrorAction SilentlyContinue
        Say ''
        Say 'Removed. OBS stays open for now but will no longer start or restart by itself.' Green
    }
}
