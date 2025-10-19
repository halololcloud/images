@echo off
setlocal

set "SCRIPT=%~dp0u.ps1"

powershell.exe -STA -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"

endlocal
