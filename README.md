# Wmi.EventLogProvider.Commands

Dieses PowerShell Module stellt Funktionen zur Verfügung, die für die Verwaltung von EventLogs dienen. Dabei wurde bei der Entwicklung darauf geachtet, den WMI Event Log Provider zu verwenden. 

Weitere Informationen finden Sie unter:
[Event Log Provider](https://docs.microsoft.com/en-us/previous-versions/windows/desktop/eventlogprov/event-log-provider)

## Voraussetzungen

Um dieses Module nutzen zu können, ist ein Windowssystem notwendig.

## Installation

Kopieren Sie das Module in eins der PowerShell Module Pfade.

## Verwendung

In diesem Beispiel wird gezeigt und erläutert, wie das Module verwendet werden kann.

```powershell
# Importieren des Moduls
Import-Module Wmi.EventLogProvider.Commands

# Gebe ein Objekt der Klasse Win32_NTEventLogFile aus.
Get-NTEventLogFile -LogFileName "Application"

# Gebe ein Objekt der Klasse Win32_NTLogEvent aus.
Get-NTLogEvent -Filter {Logfile='Application' AND RecordNumber=4}

# Sichere ein NTEventLogFile.
Backup-NTEventLogFile -LogFileName Application -destination "C:\Backup\"

# PowerShell Events erzeugen, wenn ein neues NTLogEvent erzeugt wird.
Register-NTLogEventEventHandler
```
## Hinweis
Dieses PowerShell Module wurde bewusst kein gehalten. Sollten Sie weitere Funktionen benötigen, steht das PowerShell Module **System.Diagnostics.Commands** oder das **System.Diagnostics.Eventing.Reader** in den jeweiligen Repositories zur Verfügung.
