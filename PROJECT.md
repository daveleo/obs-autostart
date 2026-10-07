---
name: OBS Autostart
status: maintained
priority:
version: 
deadline:
next: None. Finished public guide; update only if OBS or Windows behaviour changes
updated: 2026-10-07
repo: daveleo/obs-autostart
url: https://daveleo.github.io/obs-autostart/
---

# OBS Autostart

Keeps OBS Studio running on Windows: starts on boot, restarts after crashes, no Safe Mode prompt. Public guide plus downloadable kit.

## What it is for

Makes a Windows PC run OBS Studio like an appliance: OBS starts by itself when the PC boots, comes back if it closes or crashes, and never stops at the Safe Mode question after a power cut. For showrooms and installations where OBS feeds an LED screen and nobody is there to restart it. Public guide plus a download kit.

## How to run

- **Guide:** https://daveleo.github.io/obs-autostart/ (served from `index.html` on `main`).
- **Kit:** download `Expromo-OBS-Autostart.zip` from the guide (or take `kit\`), unzip on the PC.
- Before installing: Windows must sign in automatically, and OBS must be installed in its default folder. The guide explains both.

## How to use

On the OBS PC, signed in as the user that runs OBS:
- `Install.cmd`: set it up for this Windows user.
- `Pause OBS.cmd`: close OBS and keep it closed (for maintenance).
- `Resume OBS.cmd`: back to normal; OBS starts and is kept running.
- `Uninstall.cmd`: remove it again; OBS itself is not touched.

The watchdog and its log are installed in `%LOCALAPPDATA%\OBS-Appliance\`.

**Changing the kit:** edit the files in `kit\`, then rebuild `download\Expromo-OBS-Autostart.zip` so the download matches. Keep `.ps1` files ASCII-only with CRLF line endings (Windows PowerShell 5.1 misreads UTF-8 without BOM). Pushing to `main` updates the public guide.

## What is what

- `index.html`, `assets\`: the public guide.
- `kit\`: the kit files: four `.cmd` files, `setup.ps1` (does the work for them), `obs-watchdog.ps1` (keeps OBS running), `README.txt`.
- `download\Expromo-OBS-Autostart.zip`: the kit zipped for the guide's download button.

## Current state

Finished and public. Used as the standard OBS always-on setup (also in the showroom).
