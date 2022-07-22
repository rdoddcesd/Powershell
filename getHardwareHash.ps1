New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"

$HostName = hostname
$Path = "C:\HWID\"
$DataPath = $Path + "AutoPilot_$HostName.csv"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo -OutputFile $DataPath
