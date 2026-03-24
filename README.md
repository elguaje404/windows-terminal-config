\# 🟦 TRON / Matrix Terminal Config (Primus Edition)



Este repositorio contiene mi configuración personalizada de \*\*Windows Terminal\*\* y el perfil de \*\*PowerShell 7\*\*, optimizada para el rendimiento y con una estética inspirada en TRON.



!\[Preview](assets/preview.png)



\## 🚀 Características principales



\### Perfil de PowerShell (`Microsoft.PowerShell\_profile.ps1`)

\* \*\*Rendimiento optimizado\*\*: Utiliza `P/Invoke` para llamar a `GlobalMemoryStatusEx` y obtener datos de RAM de forma instantánea.

\* \*\*Uptime de alta velocidad\*\*: Implementa `GetTickCount64` para calcular el tiempo de actividad del sistema sin la latencia de WMI.

\* \*\*Dashboard Visual\*\*: Muestra información del equipo, versión de shell, conteo de procesos e información de red (IP/Gateway).

\* \*\*Estado de Disco\*\*: Incluye un indicador visual dinámico para el disco `C:` con una barra de progreso que cambia de color según el espacio libre.

\* \*\*Estética e Interacción\*\*: Arte ASCII personalizado, saludos dinámicos según la hora y un sistema de mensajes (MOTD) con resaltado de sintaxis para el usuario.



\### Windows Terminal (`settings.json`)

\* \*\*Entorno por defecto\*\*: Configurado para iniciar automáticamente con \*\*PowerShell 7\*\* (PowerShell Core).

\* \*\*Estilo Visual\*\*: Utiliza el esquema de colores "Ottosson", con un nivel de transparencia \*\*Acrylic del 70%\*\*.

\* \*\*Tipografía\*\*: Optimizado para la fuente \*\*JetBrains Mono\*\* en estilo \*\*Bold\*\*.

\* \*\*Personalización del Cursor\*\*: Cursor tipo "vintage" en color rojo (`#C50003`).

\* \*\*Atajos de Teclado\*\*: Mapeos para `Ctrl+C` (copiar), `Ctrl+V` (pegar), `Ctrl+Shift+F` (buscar) y `Alt+Shift+D` (duplicar panel).



\## 🛠️ Requisitos previos



Para que la configuración funcione correctamente, es indispensable instalar:



1\.  \*\*\[PowerShell 7](https://learn.microsoft.com/es-es/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) (Core)\*\*: \*\*Obligatorio\*\*. El perfil predeterminado está vinculado específicamente a PowerShell Core.

2\.  \*\*Fuente \[JetBrains Mono](https://www.jetbrains.com/lp/mono/)\*\*: Configurada en el archivo de ajustes para renderizar correctamente el texto en "bold".

3\.  \*\*Windows Terminal\*\*: Aplicación necesaria para ejecutar los perfiles definidos.



\## 📦 Instalación



\### 1. Perfil de PowerShell 7

Copia el archivo `Microsoft.PowerShell\_profile.ps1` en la carpeta de perfiles de PowerShell Core:

\* Ruta: `Documentos\\PowerShell\\Microsoft.PowerShell\_profile.ps1`



> \[!IMPORTANT]

> Asegúrate de colocarlo en la carpeta `PowerShell` y no en `WindowsPowerShell`, ya que esta última pertenece a la versión 5.1 del sistema.



\### 2. Configuración de Windows Terminal

1\.  Abre Windows Terminal.

2\.  Accede a la \*\*Configuración\*\* (`Ctrl + ,`).

3\.  Haz clic en \*\*Abrir archivo JSON\*\* en la parte inferior del menú lateral.

4\.  Sustituye el contenido por el archivo `settings.json` de este repositorio.



