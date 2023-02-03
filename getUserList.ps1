<#
.SYNOPSIS
    Name: getUserList.ps1
    Creates a list of User profiles when given a list of computers
.DESCRIPTION
    blob
.PARAMETER List
    CSV with header of computer containing list of computers to be queried.
.NOTES
    Version: 1.0
    Updated: 
    Release Date: 20230131
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us
.EXAMPLE
    .\getUserList.ps1 .\CompList.csv
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "Full DN of the OU being restarted")][string] $List
)

$computers = Import-Csv $list
$computerObjectList = @()
$userObjectList = @()

foreach($computer in $computers)
    {
        if (Test-Connection -ComputerName $computer.computer -Quiet)
            {
                $currentComputerObject = [PSCustomObject]@{
                    HostName = $computer.computer
                    DeviceID = $driveQuery.DeviceID
                    Size = $driveQuery.Size
                    FreeSpace = $driveQuery.FreeSpace
                    }

                $computer.computer
                $driveQuery = Get-WmiObject win32_logicaldisk -ComputerName $computer.computer | Where-Object {$_.DeviceID -eq 'c:'}
                $driveQuery | Select-Object DeviceID,Size,FreeSpace
                $computerObjectList += $currentComputerObject

                $users = Get-WMIObject -ComputerName $computer.computer -class Win32_UserProfile | Select-Object LocalPath,LastUseTime

                foreach($user in $users)
                    {
                        $currentUserObject = [PSCustomObject]@{
                            HostName = $computer.computer
                            LocalPath = $user.LocalPath
                            LastUseTime = ([WMI] '').ConvertToDateTime($user.LastUseTime)

                            }

                        $userObjectList += $currentUserObject

                    }
            }Else {
                $computer.computer
                "No connection"
            }
    }

$userObjectList | Export-Csv -NoTypeInformation ".\log\$((Get-Date).ToString("yyyyMMdd_HHmmss"))_userList.csv"
$computerObjectList | Export-Csv -NoTypeInformation ".\log\$((Get-Date).ToString("yyyyMMdd_HHmmss"))_computerList.csv"
