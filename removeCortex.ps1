# Remove Cortex by checking for CrowdStrike and determining the version to uninstall if necessary.


$Since = (Get-date).AddDays(-90)
$CortexPath = test-path "$env:ProgramFiles\Palo Alto Networks\Traps\cytool.exe"
$CSPath = test-path "$env:ProgramFiles\crowdstrike"
$LogDir = "$env:SystemDrive\mrsd"
$LogDirTest	= test-path $LogDir

#Latest and greatest Product Code to try initially
$CODE = '{4C15A746-0980-45A8-A446-AB8D7B5D2BC7}'

if (!$LogDirTest) {
    
    New-Item -Path "$env:SystemDrive\mrsd" -ItemType Directory

}

IF (!($CortexPath) -and $CSPath) {

    new-item -path "C:\mrsd " -name "FalconInstalled.log" -ItemType file
    Write-host "Falcon installed"
    exit 0
   
}


IF ($CortexPath) {


    $Pass = "<cortex unlock password>"
    $appname = "cortex"
    $path = '"C:\Program Files\Palo Alto Networks\Traps\cytool.exe"'
    $CMD = "echo $Pass | $Path protect disable"
    cmd /c $CMD
    $Check = '"C:\Program Files\Palo Alto Networks\Traps\cytool.exe"' + ' protect query'
    cmd /c $Check
    #Tamper protection gone, generate cmd to uninstall Cortex based on MSI code and log actions within C:\mrsd
    $Crtxlog = "c:\mrsd\CTexUnistall.txt"
    $proc = "msiexec /qn /x $code"
    $param = " /l*v $Crtxlog"
    $CMD = $Proc + " " + $param


    $Log = (Get-Item $Crtxlog | Measure-Object length -s).sum / 1KB
    if ($Log -gt 500) {


        Write-host "Removed"
        Exit 0
        #Created to remove all versions of Cortex


    }
    #This handles if another version is installed by determining the code to use to rip out the software.
    Else {
        $32bit = get-itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, GUID, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "^*$appname*" }
        $64bit = get-itemproperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, GUID, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "^*$appname*" }


        #$32bit.UninstallString.Substring(14)
        #$64bit.UninstallString.Substring(14)


        if (!($64bit)) {
            $AppID = $32bit.PSChildName
        }
        else {
            $AppID = $64bit.PSChildName
        }


    #Vague check to see if the software is checking in and if not, use the default password.
        $Since = (Get-date).adddays(-180)
        #$Pathcheck = "%ProgramFiles%\Palo Alto Networks\Traps\"
        $PassCheck = (Get-ChildItem -recurse | Sort-Object LastWriteTime | Select-Object -last 1).LastWriteTime
   
        IF ($PassCheck -gt $Since) {
            $Pass = "<cortex unlock password>"
        }
        Else {
            $Pass = "Password1"
        }
   
    #Same as above just with a new CODE
        $path = '"C:\Program Files\Palo Alto Networks\Traps\cytool.exe"'
        $CMD = "echo $Pass| $Path protect disable"
        cmd /c $CMD
        $Check = '"C:\Program Files\Palo Alto Networks\Traps\cytool.exe"' + ' protect query'
        cmd /c $Check
        #Tamper protection gone, generate cmd to uninstall Cortex based on MSI code and log actions within C:\mrsd
        $Crtxlog = "c:\mrsd\CTexUnistall.txt"
        $proc = "msiexec /qn /x $AppID"
        $param = " /l*v $Crtxlog"
        $CMD = $Proc + " " + $param


        cmd /c $CMD


        #check log file size to indicate COMPLETE success.
        $Log = (Get-Item $Crtxlog | Measure-Object length -s).sum / 1KB
        if ($Log -gt 500) {


            Write-host "Removed"
            Exit 0
            #Created to remove all versions of Cortex


        }


    }


}
