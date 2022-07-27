#-noninteractive -executionPolicy Bypass -noprofile -file \\tech.local\NETLOGON\MYSCRIPT.PS1

# MUST ADD ORG SPICIFIC DATA HERE
$installer = '<path to EXE>'
$cid = '<customer ID checksum>'

$installerArguments = "/install /quiet /norestart CID=$cid"
$installedPath = 'C:\Program Files\CrowdStrike\CSFalconService.exe'

"Test to see if installer is availible"
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
