$VolumeLevel = 50
$val = [int]([math]::Round(65535 * ($VolumeLevel / 100)))
$tempNir = Join-Path $env:TEMP "nircmd.exe"
if (-not (Test-Path $tempNir)) {
    $tempZip = Join-Path $env:TEMP "nircmd.zip"
    Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/nircmd.zip" -OutFile $tempZip -UseBasicParsing
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $env:TEMP)
    Remove-Item $tempZip -ErrorAction SilentlyContinue
}
Start-Process -FilePath $tempNir -ArgumentList "setsysvolume $val" -NoNewWindow -Wait
