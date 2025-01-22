<#
.SYNOPSIS
    Name: cleanupUsers.ps1
    Builds list of users not included in feed file.
.DESCRIPTION
    Given a CSV of User ID's. Builds a list of users not in CSV. List can then be used to disable, removed from groups and moved to disabled OU.
.PARAMETER feedFile
    CSV with header of userID containing list of active users.
.PARAMETER searchOU
    OU of Users to be evaluated, search is recursive
.PARAMETER adUniqueID
    Active directory Unique user identifier, ie. sAMAccountName
.PARAMETER feedUniqueID
    Feed file Unique user identifier, ie. SamAccountName
.PARAMETER logFile
    Location of Log file
.NOTES
    Version: 1.0
    Updated: 
    Release Date: 20241118
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us
.EXAMPLE
    .\cleanupUsers.ps1 -feedFile .\data\users.csv -logFile .\log\disableUsersLog.txt -searchOU "OU=Students,DC=summitlc,DC=k12,DC=or,DC=us" -adUniqueID sAMAccountName -feedUniqueID SamAccountName
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "CSV with header of userID")][string] $feedFile,
    [Parameter(Mandatory = $true, HelpMessage = "DN of OU to search")][string] $searchOU,
    [Parameter(Mandatory = $true, HelpMessage = "Active directory Unique user identifier,")][string] $adUniqueID,
    [Parameter(Mandatory = $true, HelpMessage = "Feed file Unique user identifier")][string] $feedUniqueID,
    [Parameter(Mandatory = $true, HelpMessage = "Log location")][string] $logFile
)

$users = Get-ADUser -Filter * -SearchBase $searchOU -Properties $adUniqueID
$feed = Import-Csv -Path $feedFile
$userObjectList = @()

foreach ($user in $users) {
    $adUserID = $user.$adUniqueID
    $feedUserID = $feed | Where-Object {$_.$feedUniqueID -match $adUserID} | Select-Object $feedUniqueID
    $adCurrentOU = ($user.DistinguishedName -split ",",2)[1]

    if(!$feedUserID){
        $adUserID
        $currentUserObject = [PSCustomObject]@{
            adUserID = $adUserID
            adCurrentOU = $adCurrentOU
        }
        $userObjectList += $currentUserObject
    }
}

$userObjectList | Export-Csv -Path $logFile -NoTypeInformation

#$users.count
#$filter.count
