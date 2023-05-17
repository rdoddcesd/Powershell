<#
.SYNOPSIS
    Name: disableUsers.ps1
    Disables, removes from group and moves to disabled OU.
.DESCRIPTION
    Given a CSV of SamAccountName's. Users will be disabled, removed from groups and moved to disabled OU.
.PARAMETER feedFile
    CSV with header of SamAccountName containing list of users to be diasabled and removed from all groups.
.PARAMETER logFile
    Location of Log file
.PARAMETER disabledOU
    DN of Disabled users OU
.NOTES
    Version: 1.0
    Updated: 
    Release Date: 20230515
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us
.EXAMPLE
    .\disableUsers.ps1 -feedFile users.csv -logFile log\disableUsersLog.txt -disabledOU
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "CSV with header of SamAccountName")][string] $feedFile,
    [Parameter(Mandatory = $true, HelpMessage = "Log location")][string] $logFile,
    [Parameter(Mandatory = $true, HelpMessage = "DN of Disabled users OU")][string] $disabledOU
)

function Remove-AllADGroups()
{
    Param
    (
        [Parameter(Mandatory = $true)][string] $SamAccountName
    )

    Write-Output "[$(Get-Date -UFormat "%T")] RMV-ALL-GRP: $SamAccountName" | Out-File -Append $logFile

    $stringList = ""

    # Get the AD user and also select the MemberOf and ObjectGUID attributes
    $user = Get-ADuser $SamAccountName -Properties MemberOf,ObjectGUID

    if (!($user.MemberOf))
    {
        return ""
    }

    foreach ($group in $user.MemberOf)
    {
        $groupName = "$group".Split(',')[0].Split('=')[1]

        Write-Output "[$(Get-Date -UFormat "%T")]              $($groupName)" | Out-File -Append $logFile

        Remove-ADGroupMember -Identity $groupName -Members $user.ObjectGUID -Confirm:$false
        $stringList += ("," + $groupName)
    }

    # return the list (minus the first comma)
    return $stringList.Substring(1)
}

function Disable-ADStudent()
{
    Param
    (
        [Parameter(Mandatory = $true)][string] $SamAccountName
    )

    # Disable account object in AD
    Write-Output "[$(Get-Date -UFormat "%T")] DIS-USR: $SamAccountName" | Out-File -Append $logFile
    Disable-ADAccount -Identity $samAccountName
    Move-ADObject -Identity (Get-ADuser -Identity $SamAccountName).DistinguishedName -TargetPath $disabledOU
}

$feed = Import-Csv $feedFile

foreach ($feedUser in $feed)
{

    Remove-AllADGroups -SamAccountName $feedUser.SamAccountName
    Disable-ADStudent -SamAccountName $feedUser.SamAccountName
}
