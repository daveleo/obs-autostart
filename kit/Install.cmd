@echo off
title Expromo OBS Autostart - Install
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" install
echo.
pause
