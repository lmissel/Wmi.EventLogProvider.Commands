# ---------------------------------------------------------------------
#
# Module: Wmi.EventLogProvider.Commands
#
# Beschreibung:
# Dieses PowerShell Module stellt Funktionen zur Verfügung, die für die Verwaltung von
# EventLogs dienen.
#
# ---------------------------------------------------------------------

<#
.Synopsis
    Get a NTEventlogFile.
.DESCRIPTION
    Get a NTEventlogFile.

    The Win32_NTEventlogFile WMI class represents a logical file or directory of operating system events. The file is also known as the event log.
.EXAMPLE
    Get-NTEventLogFile -LogFileName "Application"
.EXAMPLE
    Get-NTEventLogFile -LogFileName "Application" -ComputerName $env:ComputerName
#>
function Get-NTEventLogFile
{
    [CmdletBinding(DefaultParameterSetName='Default', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([Object])]
    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $LogFileName,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = "."
    )
    
    Begin
    {
        $namespace = "ROOT\CIMV2"
        $classname = "Win32_NTEventLogFile"
    }

    Process
    {
        if ($pscmdlet.ShouldProcess("$($ComputerName)", "Get a NTEventLogFile."))
        {
            $items = Get-WmiObject -Class $classname -Namespace $namespace -ComputerName $ComputerName | Where-Object {$_.LogFileName -eq $LogFileName}
        }
    }

    End
    {
        return $items
    }
}

<#
.Synopsis
    Get all Sources of a NTEventlogFile.
.DESCRIPTION
    Get all Sources of a NTEventlogFile.
.EXAMPLE
    Get-NTEventLogFileSources -LogFileName "Application"
.EXAMPLE
    Get-NTEventLogFileSources -LogFileName "Application" -ComputerName $env:ComputerName
#>
function Get-NTEventLogFileSources
{
    [CmdletBinding(DefaultParameterSetName='Default', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([Object])]
    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $LogFileName,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = "."
    )
    
    Begin
    {
        $namespace = "ROOT\CIMV2"
        $classname = "Win32_NTEventLogFile"
    }

    Process
    {

        $items = Get-WmiObject -Class $classname -Namespace $namespace -ComputerName $ComputerName | Where-Object {$_.LogFileName -eq $LogFileName}
    }

    End
    {
        return $items.Sources
    }
}

<#
.Synopsis
    Get all NTLogEvent.
.DESCRIPTION
    Get all NTLogEvent.
.EXAMPLE
    Get-NTLogEvent -LogFileName 'Microsoft.Network.Commands' -ComputerName $env:COMPUTERNAME
.EXAMPLE
    Get-NTLogEvent -Filter {Logfile='Microsoft.Network.Commands' AND RecordNumber=4}
#>
function Get-NTLogEvent
{
    [CmdletBinding(DefaultParameterSetName='Default', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([Object])]
    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Default')]
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='RecordNumber')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $LogFile,

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Default')]
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Filter')]
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=2,
                   ParameterSetName='RecordNumber')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = ".",

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Filter')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $Filter,

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='RecordNumber')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $RecordNumber
    )

    Begin
    {
        $classname = "Win32_NTLogEvent"
        $namespace = "ROOT\CIMV2"
    }

    Process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Default')
        {
            $Query = "SELECT * FROM $($classname) WHERE Logfile='$($LogFile)'"
        }

        if ($PSCmdlet.ParameterSetName -eq 'Filter')
        {
            $Query = "SELECT * FROM $($classname) WHERE $($Filter)"
        }

        if ($PSCmdlet.ParameterSetName -eq 'RecordNumber')
        {
            $Query = "SELECT * FROM $($classname) WHERE Logfile='$($LogFile)' AND RecordNumber=$($RecordNumber)"
        }

        $items = Get-WmiObject -Query $Query -ComputerName $ComputerName -Namespace $namespace
    }

    End
    {
        return $items
    }
}

<#
.Synopsis
    Backup a NTLogEventFile.
.DESCRIPTION
    Backup a NTLogEventFile.
.EXAMPLE
    Backup-NTEventLogFile -LogFileName Dienststeuerung -fileName C:\Support\Dienststeuerung.evtx
#>
function Backup-NTEventLogFile
{
    [CmdletBinding(DefaultParameterSetName='Default', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $LogFileName = 'security',


        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = ".",


        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=2,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $destination
    )

    Begin
    {
        $namespace = "ROOT\CIMV2"
        $classname = "Win32_NTEventLogFile"
    }

    Process
    {
        $NTEventLogFiles = Get-WmiObject -Class $classname -Namespace $namespace -ComputerName $ComputerName -Filter "LogfileName = '$LogFileName'"
        foreach ($NTEventLogFile in $NTEventLogFiles)
        {
            $filename = Join-Path -Path $destination -ChildPath "$($NTEventLogFile.LogFileName)-$((Get-Date -Format 's').Replace(':','-')).$($NTEventLogFile.Extension)"
            Write-Debug $filename

            [void]$NTEventLogFile.BackupEventlog($fileName)
        }
    }

    End
    {
    }
}

<#
.Synopsis
    Clear a NTLogEventFile.
.DESCRIPTION
    Clear a NTLogEventFile.
.EXAMPLE
    Clear-NTEventLogFile -LogFileName Dienststeuerung
#>
function Clear-NTEventLogFile
{
    [CmdletBinding(DefaultParameterSetName='Default', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $LogFileName = 'security',


        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = "."
    )

    Begin
    {
        $namespace = "ROOT\CIMV2"
        $classname = "Win32_NTEventLogFile"
    }

    Process
    {
        $NTEventLogFiles = Get-WmiObject -Class $classname -Namespace $namespace -ComputerName $ComputerName | Where-Object {$_.LogFileName -eq $LogFileName}
        foreach ($NTEventLogFile in $NTEventLogFiles)
        {
            [void]$NTEventLogFile.ClearEventlog()
        }
    }

    End
    {
    }
}

<#
.Synopsis
    Register a NTLogEventEventHandler.
.DESCRIPTION
    Register a NTLogEventEventHandler for your PowerShell Script.
    This NTLogEventEventHandler registered all new Events as a PowerShell Event or use your own  Scriptbock.
.EXAMPLE
    Register-NTLogEventEventHandler
.EXAMPLE
    Register-NTLogEventEventHandler -ScriptBlock { Write-Host "New Event." }
#>
function Register-NTLogEventEventHandler
{
    [CmdletBinding(DefaultParameterSetName='Default', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([Object])]
    param(
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = ".",

        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Default')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ScriptBlock] $ScriptBlock = {(New-Event -SourceIdentifier "Win32_NTLogEvent" -Sender $args[0] -EventArguments $Event)}
    )
    
    Begin
    {
    }
    
    Process
    {
        $Query = "SELECT * FROM __InstanceCreationEvent WHERE TargetInstance ISA 'Win32_NTLogEvent'"
        Register-WmiEvent -Query $Query -SourceIdentifier "NTLogEventEventHandler" -ComputerName $ComputerName -Action $ScriptBlock
    }

    End
    {
    }
}
