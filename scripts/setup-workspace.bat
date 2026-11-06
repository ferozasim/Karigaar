@echo off
REM =======================================================
REM  Karigaar One-Click Workspace Setup Launcher
REM =======================================================
TITLE Karigaar Workspace Environment Setup

echo =======================================================
echo     KARIGAAR WORKSPACE SETUP LAUNCHER
echo =======================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-environment.ps1"

echo.
echo Process completed. Press any key to exit.
pause >nul
