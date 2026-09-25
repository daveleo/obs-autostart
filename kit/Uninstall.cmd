@echo off
title Expromo OBS Autostart - Uninstall
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" uninstall
echo.
pause
