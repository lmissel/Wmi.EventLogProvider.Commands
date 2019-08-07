$destination = "C:\Backup\Application"

if (-not(Test-Path $destination))
{
    mkdir $destination
}

Backup-NTEventLogFile -LogFileName Application -destination $destination

Get-ChildItem -Path $destination | where {$_.CreationTime -lt (Get-Date).AddDays(-30)} | Remove-Item