<#
.SYNOPSIS
    Name: copyGroupToGroup.ps1
    Copys users of one group to another group
.DESCRIPTION
    Copys users of one group to another group. Uses perameters to set source and destination group.
.PARAMETER sourcegroup
    Group name to use as source
.PARAMETER destinationgroup
    Group name of destination
.NOTES
    Version: 1.0
    Updated: 
    Release Date: 20230405
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us
.EXAMPLE
    .\copyGroupToGroup.ps1 -sourcegroup source -destinationgroup destination
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "Group name to use as source")][string] $sourcegroup,
    [Parameter(Mandatory = $true, HelpMessage = "Group name of destination")][string] $destinationgroup
)

Get-ADGroupMember -Identity $sourcegroup | ForEach-Object {Add-ADGroupMember -Identity $destinationgroup -Members $_.distinguishedName}
