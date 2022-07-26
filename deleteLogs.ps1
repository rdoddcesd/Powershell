# https://github.com/rdoddcesd/Powershell/blob/main/deleteLogs.ps1
# .\deleteLogs.ps1 -hostname ad01 -driveletter e -logcount 100

param 
    (
        [Parameter(Mandatory=$true)] $hostname,
        [Parameter(Mandatory=$true)] $driveletter,
	[Parameter(Mandatory=$true)] $logCount
    )

$logPath = "\\" + $hostname + "\" + $driveletter + "$" + "\Winevt\Logs"
$logSearch = "\\" + $hostname + "\" + $driveletter + "$" + "\Winevt\Logs\Archive*"
$logCount = $logCount

$itemList = Get-ChildItem -Path $logSearch | Sort-Object LastWriteTime -desc  | Select-Object -Skip $logCount

ForEach ($item in $itemList) {
    $itemPath = $logPath + "\" + $item.name
    $itemPath
    Remove-Item -LiteralPath $itemPath
}
