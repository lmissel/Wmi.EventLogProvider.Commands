# Wmi.EventLogs.Commands

# ...retrieve information about the Security event log?
function Get-NTEventLogFile
{
    param(
        $LogFileName = 'security',
        $strComputer = "."
    )
    
    $Objekte = @()
    $colLogFiles = Get-WmiObject -Class Win32_NTEventLogFile -ComputerName $strComputer | Where-Object {$_.LogFileName -eq $LogFileName}
    foreach ($objLogFile in $colLogFiles) 
    {
        $Objekt = New-Object -TypeName PSObject
        $Objekt | Add-Member -MemberType NoteProperty -Name "Record Number" -Value $objLogFile.NumberOfRecords
        $Objekt | Add-Member -MemberType NoteProperty -Name "Maximum Size" -Value $objLogFile.MaxFileSize
        $Objekte += $Objekt
    }
    $Objekte
}

