@echo off
title Expromo OBS Autostart - Resume
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" resume
echo.
pause
