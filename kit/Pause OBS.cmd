@echo off
title Expromo OBS Autostart - Pause
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" pause
echo.
pause
