# ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ██████╗ ██████╗ ██╗███╗   ███╗██╗   ██╗███████╗    ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
# ██╔══██╗██╔══██╗██║████╗ ████║██║   ██║██╔════╝    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
# ██████╔╝██████╔╝██║██╔████╔██║██║   ██║███████╗    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
# ██╔═══╝ ██╔══██╗██║██║╚██╔╝██║██║   ██║╚════██║    ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
# ██║     ██║  ██║██║██║ ╚═╝ ██║╚██████╔╝███████║    ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
# ╚═╝     ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝    ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝                                                                                                    
#                                  Estilo TRON + Matrix + Datos útiles      
# ════════════════════════════════════════════════════════════════════════════════════════════════════════════════
 
# Variable para el usuario actual
$currentUser = $env:USERNAME

Write-Host @"
██╗             ██╗  ██╗ ██████╗ ██╗  ██╗
╚██╗            ██║  ██║██╔═████╗██║  ██║
 ╚██╗           ███████║██║██╔██║███████║
 ██╔╝           ╚════██║████╔╝██║╚════██║
██╔╝███████╗         ██║╚██████╔╝     ██║
╚═╝ ╚══════╝         ╚═╝ ╚═════╝      ╚═╝
"@ -ForegroundColor DarkRed
 
# ═════ P/INVOKE — GlobalMemoryStatusEx (sin WMI, instantáneo) ═════
$memType = @'
using System;
using System.Runtime.InteropServices;
public struct MEMORYSTATUSEX {
    public uint  dwLength;
    public uint  dwMemoryLoad;
    public ulong ullTotalPhys;
    public ulong ullAvailPhys;
    public ulong ullTotalPageFile;
    public ulong ullAvailPageFile;
    public ulong ullTotalVirtual;
    public ulong ullAvailVirtual;
    public ulong ullAvailExtendedVirtual;
}
public class MemInfo {
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool GlobalMemoryStatusEx(ref MEMORYSTATUSEX lpBuffer);
}
'@
if (-not ([System.Management.Automation.PSTypeName]'MemInfo').Type) {
    Add-Type -TypeDefinition $memType
}
$mem = New-Object MEMORYSTATUSEX
$mem.dwLength = [System.Runtime.InteropServices.Marshal]::SizeOf($mem)
[MemInfo]::GlobalMemoryStatusEx([ref]$mem) | Out-Null
 
$ramTotal = [math]::Round($mem.ullTotalPhys / 1GB, 2)
$ramFree  = [math]::Round($mem.ullAvailPhys / 1GB, 2)
$ramUsed  = [math]::Round($ramTotal - $ramFree, 2)
 
# ═════ UPTIME — GetTickCount64 (sin WMI) ═════
$tickType = @'
using System.Runtime.InteropServices;
public class Uptime {
    [DllImport("kernel32.dll")] public static extern ulong GetTickCount64();
}
'@
if (-not ([System.Management.Automation.PSTypeName]'Uptime').Type) {
    Add-Type -TypeDefinition $tickType
}
$uptime       = [System.TimeSpan]::FromMilliseconds([Uptime]::GetTickCount64())
$uptimeString = "{0}d {1}h {2}m" -f $uptime.Days, $uptime.Hours, $uptime.Minutes
 
# ═════ DATOS RÁPIDOS (sin WMI, no bloquean) ═════
 
$hostname     = $env:COMPUTERNAME
$shellVersion = $PSVersionTable.PSVersion.ToString()
$procCount    = (Get-Process).Count
 
# Red — solo Get-Net*, muy rápido
$ipInfo  = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" -and $_.IPAddress -notlike "169.*" } | Select-Object -First 1
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue | Select-Object -First 1).NextHop
 
# Disco — PSDrive es instantáneo
$disk        = Get-PSDrive C
$used        = $disk.Used
$free        = $disk.Free
$total       = $used + $free
$percentFree = [math]::Round(($free / $total) * 100)
$percentUsed = 100 - $percentFree
$blocks      = 20
$filled      = [math]::Round(($percentUsed / 100) * $blocks)
$bar         = ("█" * $filled) + ("░" * ($blocks - $filled))
 
$barColor = if ($percentFree -lt 20) { "DarkRed" } elseif ($percentFree -lt 40) { "Yellow" } else { "DarkGreen" }
 
# ═════ FUNCIÓN PARA RESALTAR TEXTO ═════
function Write-Mixed {
    param([string]$text, [string]$highlight = "")
    if ($highlight -eq "") { Write-Host $text -ForegroundColor DarkGreen; return }
    $parts = $text -split [regex]::Escape($highlight)
    for ($i = 0; $i -lt $parts.Count; $i++) {
        Write-Host $parts[$i] -ForegroundColor DarkGreen -NoNewline
        if ($i -lt $parts.Count - 1) { Write-Host $highlight -ForegroundColor DarkRed -NoNewline }
    }
    Write-Host ""
}
 
# ════════════════════════════════════════════════════════════
#                         PANEL TRON
# ════════════════════════════════════════════════════════════
 
Write-Host "╔═════════════════════════════════════════════════════╗" -ForegroundColor DarkGreen
 
Write-Host "║  Usuario        : " -ForegroundColor DarkGreen -NoNewline
Write-Host ($currentUser.PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  Equipo         : " -ForegroundColor DarkGreen -NoNewline
Write-Host ($hostname.PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  Shell          : " -ForegroundColor DarkGreen -NoNewline
Write-Host ($shellVersion.PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  Uptime         : " -ForegroundColor DarkGreen -NoNewline
Write-Host ($uptimeString.PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  IP / Gateway   : " -ForegroundColor DarkGreen -NoNewline
Write-Host (("$($ipInfo.IPAddress) | $gateway").PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  RAM usada      : " -ForegroundColor DarkGreen -NoNewline
Write-Host ("$ramUsed GB / $ramTotal GB".PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  Procesos       : " -ForegroundColor DarkGreen -NoNewline
Write-Host ($procCount.ToString().PadRight(34)) -ForegroundColor DarkRed -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "║  Disco C        : " -ForegroundColor DarkGreen -NoNewline
Write-Host ("[$bar] $percentFree% libre".PadRight(34)) -ForegroundColor $barColor -NoNewline
Write-Host "║" -ForegroundColor DarkGreen
 
Write-Host "╚═════════════════════════════════════════════════════╝" -ForegroundColor DarkGreen
 
# ═════ SALUDO DINÁMICO CON HIGHLIGHT ═════
$hour = (Get-Date).Hour
if     ($hour -lt 12) { $greeting = "Buenos días, $currentUser." }
elseif ($hour -lt 18) { $greeting = "Buenas tardes, $currentUser." }
else                  { $greeting = "Buenas noches, $currentUser." }
Write-Mixed -text $greeting -highlight $currentUser
 
# ═════ MOTD CON RESALTADO ═════
$messages = @(
    @{ text = "Estado del sistema: operativo.";                                    highlight = "operativo"         },
    @{ text = "Terminal lista para recibir sus instrucciones, $currentUser.";       highlight = $currentUser        },
    @{ text = "Todos los servicios principales están activos.";                    highlight = "activos"           },
    @{ text = "Carga del sistema dentro de parámetros normales.";                  highlight = "parámetros normales"},
    @{ text = "Esperando sus instrucciones, $currentUser.";                         highlight = $currentUser        },
    @{ text = "$currentUser, la terminal está lista para recibir sus instrucciones."; highlight = $currentUser     },
    @{ text = "$currentUser, puede continuar.";                                     highlight = $currentUser        },
    @{ text = "$currentUser, ¿en qué puedo ayudarle?";                              highlight = $currentUser        },
    @{ text = "La terminal está lista para recibir sus instrucciones, $currentUser."; highlight = $currentUser     },
    @{ text = "Bienvenido de nuevo, $currentUser. ¿En qué puedo ayudarle hoy?";      highlight = $currentUser        } 
)
$msg = Get-Random $messages
Write-Mixed -text $msg.text -highlight $msg.highlight