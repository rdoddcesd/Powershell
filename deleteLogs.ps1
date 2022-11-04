$logPath = 'E:\Winevt\Logs'
$logSearch = 'E:\Winevt\Logs\Archive*'
$logCount = 70

$itemList = Get-ChildItem -Path $logSearch | Sort-Object LastWriteTime -desc  | Select-Object -Skip $logCount

ForEach ($item in $itemList) {
    $itemPath = $logPath + "\" + $item.name
    $itemPath
    Remove-Item -LiteralPath $itemPath
}
