<# Create Event Logs Collections Directory. Change as needed #>
New-Item -Force $Env:SystemDrive\Collections\EventLogs -ItemType Directory

<#Iterate through All Windows Event Logs where record count is not zero or null, replace a string and
use wevutil.exe to export those event logs #>
Get-winevent  -Listlog  * |  Where-Object { $_.RecordCount } | select  Logname, Logfilepath | ForEach-Object -Process { 
$name = $_.Logname
$newname = $name.Replace("/","-")
wevtutil.exe EPL $name  $Env:SystemDrive\Collections\EventLogs\$newname.evtx
}

<# Compress Event Logs #>
Get-ChildItem -Path $Env:SystemDrive\Collections\EventLogs | Compress-Archive -DestinationPath $Env:SystemDrive\Collections\EventLogs\Archived_WinLogs

<# Remove Event Logs to save space and cleanup #>
Get-ChildItem -Path $Env:SystemDrive\Collections\EventLogs *.evtx | foreach { Remove-Item -Path $_.FullName }
