# Expromo OBS Autostart - watchdog
# Keeps OBS Studio running: starts it after Windows sign-in, restarts it if it
# closes or crashes, and clears the crash marker so OBS never asks about Safe Mode.
# Installed by Install.cmd. Guide: https://daveleo.github.io/obs-autostart/

$ErrorActionPreference = 'Stop'

# ---- Configuration ----

$ObsExe = 'C:\Program Files\obs-studio\bin\64bit\obs64.exe'
$ObsDir = Split-Path -Parent $ObsExe

# Standard NON-PORTABLE OBS installation
$SentinelDir = Join-Path $env:APPDATA 'obs-studio\.sentinel'

$Root = Join-Path $env:LOCALAPPDATA 'OBS-Appliance'
$LogFile = Join-Path $Root 'watchdog.log'
$StopFile = Join-Path $Root 'STOP'

# Allow Windows, GPU drivers and displays time to initialise
$StartupDelaySeconds = 20

# Delay after OBS dies before restarting it
$RestartDelaySeconds = 5

# Fixed appliance-style OBS startup
$ObsArguments = '--minimize-to-tray --disable-updater --disable-missing-files-check'


# ---- Functions ----

function Write-Log {
    param([string]$Message)

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $LogFile -Value "$timestamp  $Message"
}

function Clear-ObsCrashSentinel {

    if (-not (Test-Path $SentinelDir)) {
        return
    }

    $files = Get-ChildItem `
        -Path $SentinelDir `
        -Filter 'run_*' `
        -File `
        -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        try {
            Remove-Item $file.FullName -Force -ErrorAction Stop
            Write-Log "Removed stale sentinel: $($file.Name)"
        }
        catch {
            Write-Log "ERROR removing sentinel $($file.FullName): $($_.Exception.Message)"
        }
    }
}


# ---- Main ----

New-Item -ItemType Directory -Path $Root -Force | Out-Null

Write-Log 'OBS watchdog started.'

if (-not (Test-Path $ObsExe)) {
    Write-Log "FATAL: OBS executable not found: $ObsExe"
    exit 10
}

Write-Log "Initial startup delay: $StartupDelaySeconds seconds."
Start-Sleep -Seconds $StartupDelaySeconds


while (-not (Test-Path $StopFile)) {

    # If OBS is already running, don't start another copy.
    $existing = Get-Process -Name 'obs64' -ErrorAction SilentlyContinue |
        Select-Object -First 1

    if ($existing) {

        Write-Log "OBS already running. PID=$($existing.Id). Waiting for it to exit."

        try {
            $existing.WaitForExit()
        }
        catch {
            Write-Log "Existing OBS process disappeared."
        }

        if (Test-Path $StopFile) {
            break
        }

        Write-Log "OBS stopped. Restarting in $RestartDelaySeconds seconds."
        Start-Sleep -Seconds $RestartDelaySeconds
        continue
    }


    # OBS 32.2.1 will display the Safe Mode dialog if an old
    # run_* sentinel exists. Remove it BEFORE starting OBS.
    Clear-ObsCrashSentinel


    try {

        Write-Log 'Starting OBS.'

        $process = Start-Process `
            -FilePath $ObsExe `
            -ArgumentList $ObsArguments `
            -WorkingDirectory $ObsDir `
            -PassThru

        Write-Log "OBS started. PID=$($process.Id)."

        $process.WaitForExit()

        $exitCode = $process.ExitCode
        Write-Log "OBS exited. ExitCode=$exitCode."
    }
    catch {
        Write-Log "ERROR starting/watching OBS: $($_.Exception.Message)"
    }


    if (Test-Path $StopFile) {
        break
    }

    Write-Log "Restarting OBS in $RestartDelaySeconds seconds."
    Start-Sleep -Seconds $RestartDelaySeconds
}

Write-Log 'STOP marker detected. Watchdog exiting.'
exit 0