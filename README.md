# Wmi.EventLogs.Commands

Dieses PowerShell Module stellt Funktionen zur Verfügung, die für die Verwaltung von EventLogs dienen.

## Voraussetzungen

Um dieses Module nutzen zu können, ist ein Windowssystem notwendig.

## Installation

Kopieren Sie das Module in eins der PowerShell Module Pfade.

## Verwendung

In diesem Beispiel wird gezeigt und erläutert, wie das Module verwendet werden kann.

```powershell
# Importieren des Moduls
Import-Module Wmi.EventLogs.Commands

# Gebe ein Objekt der Klasse Win32_NTEventLogFile aus.
Get-NTEventLogFile -LogFileName "Application"

# Gebe ein Objekt der Klasse Win32_NTLogEvent aus.
Get-NTLogEvent -Filter {Logfile='Application' AND RecordNumber=4}

# Sichere ein NTEventLogFile.
Backup-NTEventLogFile -LogFileName Application -destination "C:\Backup\"

```
