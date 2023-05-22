$installer = '\\ortrail.k12.or.us\SYSVOL\ortrail.k12.or.us\installers\FalconWindowsSensor6-40-15406.exe'
$cid = '<falcon CID goes here>'
$sophosPath = "C:\Program Files\Sophos"

$installerArguments = "/install /quiet /norestart CID=$cid"
$installedPath = 'C:\Program Files\CrowdStrike\CSFalconService.exe'

if($sophosPath) {
    "Sophos is installed"
} Else{
    continue
}

if($sophosPath) {
    "Sophos is still installed"
} Else{
    "Test if Falcon installer is availible"
    if (Test-Path -Path $installer) {
        "Path exists!"
        "Test to see if Falcon in installed"
        if (Test-Path -Path $installedPath) {
            "Falcon is installed!"
        } else {
            Start-Process -FilePath $installer -ArgumentList $installerArguments -NoNewWindow
            "Falcon has been installed!"
        }
    } else {
        "Installer is not availible."
    }
}
#powershell.exe -noninteractive -executionPolicy Bypass -noprofile -file \\tech.local\NETLOGON\MYSCRIPT.PS1
