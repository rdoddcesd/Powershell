<#
.SYNOPSIS
    Name: addGroup.ps1
    Adds user to group
.DESCRIPTION
    Created to add users to groups based on roster data. Takes CSV input.
.PARAMETER feedFile
    CSV with list of users samAccountName.
.PARAMETER feedUniqueID
    Feed file Unique user identifier, ie. SamAccountName
.PARAMETER groupName
    AD Group Name
.NOTES
    Version: 1.0
    Updated: 
    Release Date: 20230213
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us
.EXAMPLE
    .\addGroup.ps1 -feedFile .\data\adstudents-LOSD_all.csv -groupName LIC_GoogleEducationPlus_Student -feedUniqueID SamAccountName
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "CSV containing studentID/group assignment")][string] $feedUniqueID,
    [Parameter(Mandatory = $true, HelpMessage = "CSV containing studentID/group assignment")][string] $groupName,
    [Parameter(Mandatory = $true, HelpMessage = "CSV containing studentID/group assignment")][string] $feedFile
)

$feed = Import-Csv $feedFile

foreach($user in $feed)
    {
        Add-ADGroupMember -Identity $groupName -Members $user.$feedUniqueID
    }
