# OBS Autostart — Claude instructions

Workspace rules in `D:\Work\CLAUDE.md` apply. Keep `PROJECT.md` and `CHANGELOG.md` current.

## What this is

A finished, public guide plus a download kit that makes a Windows PC run OBS Studio like an appliance: start on boot, restart after a crash, no Safe Mode prompt after a power cut. Used as Expromo's standard OBS always-on setup (also in the showroom). The guide is `index.html`; the kit is in `kit\`. See `PROJECT.md`.

## How to run / build

- Guide: served from `index.html` on `main` at daveleo.github.io/obs-autostart.
- Kit on the OBS PC (signed in as the OBS user): `Install.cmd`, `Pause OBS.cmd`, `Resume OBS.cmd`, `Uninstall.cmd`.
- After editing `kit\`, rebuild `download\Expromo-OBS-Autostart.zip` so the download matches the files.

## Rules specific to this project

- Pushing to `main` updates the public guide: ask before pushing.
- Keep `.ps1` files **ASCII-only with CRLF** line endings — Windows PowerShell 5.1 misreads UTF-8 without BOM.
- Any change to `kit\` must be followed by rebuilding the zip, or the download drifts from the source.
