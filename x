param([string]$Url="https://github.com/halololcloud/images/blob/main/borov.jpg?raw=true")
if ([System.Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    Start-Process powershell.exe -ArgumentList "-NoProfile -STA -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`" -Url `"$Url`"" -WindowStyle Hidden -Wait
    exit
}
Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase
$tempFile=[IO.Path]::Combine($env:TEMP,"fullscreen_image.jpg")
Invoke-WebRequest -Uri $Url -OutFile $tempFile -UseBasicParsing
$fs=[IO.File]::OpenRead($tempFile)
$bi=New-Object System.Windows.Media.Imaging.BitmapImage
$bi.BeginInit();$bi.StreamSource=$fs;$bi.CacheOption="OnLoad";$bi.EndInit();$fs.Close()
$img=New-Object System.Windows.Controls.Image
$img.Source=$bi
$img.Stretch="UniformToFill"
$w=New-Object System.Windows.Window
$w.WindowStyle="None"
$w.ResizeMode="NoResize"
$w.WindowState="Maximized"
$w.Topmost=$true
$w.Background=[System.Windows.Media.Brushes]::Black
$w.Content=$img
$w.Cursor=[System.Windows.Input.Cursors]::None
$w.ShowInTaskbar=$false
$w.Add_PreviewKeyDown([System.Windows.Input.KeyEventHandler]{ param($s,$e) $e.Handled=$true })
$w.Add_PreviewKeyUp([System.Windows.Input.KeyEventHandler]{ param($s,$e) $e.Handled=$true })
$w.Add_PreviewTextInput([System.Windows.Input.TextCompositionEventHandler]{ param($s,$e) $e.Handled=$true })
$w.Add_PreviewMouseDown([System.Windows.Input.MouseButtonEventHandler]{ param($s,$e) $e.Handled=$true })
$w.Add_PreviewMouseUp([System.Windows.Input.MouseButtonEventHandler]{ param($s,$e) $e.Handled=$true })
$w.Add_PreviewMouseMove([System.Windows.Input.MouseEventHandler]{ param($s,$e) $e.Handled=$true })
$w.Add_PreviewMouseWheel([System.Windows.Input.MouseWheelEventHandler]{ param($s,$e) $e.Handled=$true })
try{$w.ShowDialog()|Out-Null}finally{Remove-Item -Path $tempFile -ErrorAction SilentlyContinue}
