# ---------------------------------------------------------------------
#
# Module: Wmi.EventLogs.Commands
#
# Beschreibung:
# 
#
# ---------------------------------------------------------------------

# ...retrieve information about the Security event log?
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

        $items = Get-WmiObject -Class $classname -Namespace $namespace -ComputerName $ComputerName | Where-Object {$_.LogFileName -eq $LogFileName}
    }

    End
    {
        return $items
    }
}

# ...read events from the event logs?
# Get-NTLogEvent -Filter {Logfile='Microsoft.Network.Commands'}
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
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=1,
                   ParameterSetName='Query')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $ComputerName = ".",

        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Query')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $Filter
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
            $items = Get-WmiObject -Query "SELECT * FROM $($classname) WHERE Logfile='$($LogFileName)'" -ComputerName $ComputerName -Namespace $namespace
        }

        if ($PSCmdlet.ParameterSetName -eq 'Query')
        {
            $Query = "SELECT * FROM $($classname) WHERE $($Filter)"
            $items = Get-WmiObject -Query $Query -ComputerName $ComputerName -Namespace $namespace
        }
    }

    End
    {
        return $items
    }
}

# ...back up an event log?
# Backup-NTEventLogFile -LogFileName Dienststeuerung -fileName C:\Support\Dienststeuerung.evtx
function Backup-NTEventLogFile
{
    param(
        $LogFileName = 'security',
        $ComputerName = ".",
        $fileName
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
            [void]$NTEventLogFile.BackupEventlog($fileName)
        }
    }

    End
    {
    }
}

# ...clear my event logs?
function Clear-NTEventLogFile
{
    param(
        $LogFileName = 'security',
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