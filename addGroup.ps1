<#
.SYNOPSIS
    Name: addGroup.ps1
    Adds user to group
.DESCRIPTION
    Created to add users to groups based on roster data. Takes CSV input.
.PARAMETER RosterData
    CSV with header of studentid and group.
.NOTES
    Version: 1.0
    Updated: 
    Release Date: 20230213
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us
.EXAMPLE
    .\addGroup.ps1 .\groupData.csv
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "CSV containing studentID/group assignment")][string] $RosterData
)

$data = Import-Csv $RosterData

foreach($student in $data)
    {
        $studentid = $student.studentid
        $user = Get-ADUser -Filter "employeeID -eq $studentid" | Select-Object samaccountname
        Add-ADGroupMember -Identity $student.group -Members $user
    }
