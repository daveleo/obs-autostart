# Expromo OBS Autostart

Makes OBS Studio start by itself when the PC boots, come back if it closes or crashes, and
never stop to ask about Safe Mode after a power cut.

**Guide:** https://daveleo.github.io/obs-autostart/

- `kit/` - the files that go into the download (`Install.cmd`, `Pause OBS.cmd`,
  `Resume OBS.cmd`, `Uninstall.cmd`, `obs-watchdog.ps1`, `setup.ps1`, `README.txt`)
- `download/Expromo-OBS-Autostart.zip` - the same files, zipped for the guide's download button
- `index.html` - the guide (GitHub Pages, `main` branch root)

After changing anything in `kit/`, rebuild the ZIP so the download matches. `.ps1` files must
stay ASCII-only (Windows PowerShell 5.1 misreads UTF-8 without BOM) and CRLF.
