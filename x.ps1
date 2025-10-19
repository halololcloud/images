$regPath = "HKCU:\Software\PrankFlip"
if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Native {
    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Ansi)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmDeviceName;
        public ushort dmSpecVersion;
        public ushort dmDriverVersion;
        public ushort dmSize;
        public ushort dmDriverExtra;
        public uint dmFields;
        public int dmPositionX;
        public int dmPositionY;
        public uint dmDisplayOrientation;
        public uint dmDisplayFixedOutput;
        public short dmColor;
        public short dmDuplex;
        public short dmYResolution;
        public short dmTTOption;
        public short dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string dmFormName;
        public ushort dmLogPixels;
        public uint dmBitsPerPel;
        public uint dmPelsWidth;
        public uint dmPelsHeight;
        public uint dmDisplayFlags;
        public uint dmDisplayFrequency;
        public uint dmICMMethod;
        public uint dmICMIntent;
        public uint dmMediaType;
        public uint dmDitherType;
        public uint dmReserved1;
        public uint dmReserved2;
        public uint dmPanningWidth;
        public uint dmPanningHeight;
    }
    [DllImport("user32.dll", CharSet=CharSet.Ansi)]
    public static extern int EnumDisplaySettings(string lpszDeviceName, int iModeNum, ref DEVMODE lpDevMode);
    [DllImport("user32.dll", CharSet=CharSet.Ansi)]
    public static extern int ChangeDisplaySettingsEx(string lpszDeviceName, ref DEVMODE lpDevMode, IntPtr hwnd, uint dwFlags, IntPtr lParam);
    [DllImport("user32.dll")]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, out bool pvParam, uint fWinIni);
    [DllImport("user32.dll")]
    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, bool pvParam, uint fWinIni);
}
"@ -PassThru | Out-Null
$SPI_GETMOUSEBUTTONSWAP = 0x21
$SPI_SETMOUSEBUTTONSWAP = 0x20
$ENUM_CURRENT_SETTINGS = -1
$DM_DISPLAYORIENTATION = 0x00000080
$DMDO_180 = 2
$dev = New-Object Native+DEVMODE
$dev.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Native+DEVMODE])
[Native]::EnumDisplaySettings($null, $ENUM_CURRENT_SETTINGS, [ref]$dev) | Out-Null
$origOrientation = [int]$dev.dmDisplayOrientation
$origWidth = [int]$dev.dmPelsWidth
$origHeight = [int]$dev.dmPelsHeight
$origSwap = $false
[Native]::SystemParametersInfo($SPI_GETMOUSEBUTTONSWAP,0,[ref]$origSwap,0) | Out-Null
Set-ItemProperty -Path $regPath -Name OrigOrientation -Value $origOrientation -Force
Set-ItemProperty -Path $regPath -Name OrigWidth -Value $origWidth -Force
Set-ItemProperty -Path $regPath -Name OrigHeight -Value $origHeight -Force
Set-ItemProperty -Path $regPath -Name OrigSwap -Value ([int]($origSwap -eq $true)) -Force
$newDev = $dev
$newDev.dmFields = $newDev.dmFields -bor $DM_DISPLAYORIENTATION
$newDev.dmDisplayOrientation = $DMDO_180
[Native]::ChangeDisplaySettingsEx($null, [ref]$newDev, [IntPtr]::Zero, 0, [IntPtr]::Zero) | Out-Null
$newSwap = -not $origSwap
[Native]::SystemParametersInfo($SPI_SETMOUSEBUTTONSWAP,0,$newSwap,0x01u) | Out-Null
