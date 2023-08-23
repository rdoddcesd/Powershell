<#
.SYNOPSIS
    Name: passwordMaintenance.ps1
    Reset users passwords or log last password change
  
.DESCRIPTION
    Provided a CSV of users, reset there password or log users password last reset date.

.NOTES

    Release Date: Aug 23, 2023
   
    Author:
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology Services
    rdodd@clackesd.k12.or.us

.EXAMPLE
    Reset users passwords...
    passwordMaintenance.ps1 -feedUsers .\feedUsers.csv -logFile .\log\resetPasswordLog20230823.log

    Generate list of last password change
    passwordMaintenance.ps1 -feedUsers .\feedUsers.csv -logFile .\log\resetPasswordLog20230823.log -passLastSet
#>



Param
(
    [Parameter(Position = 0, Mandatory = $true)][Object[]] $feedUsers,
    [Parameter(Position = 1, Mandatory = $false)][Switch] $passLastSet,
    [Parameter(Position = 2, Mandatory = $true)][String] $logFile
)

foreach ($user in Import-Csv -Path $feedUsers)
{
    if ($passLastSet)
    {
        $userInfo = Get-ADUser -Identity $user.samaccountname -Properties samaccountname,pwdLastSet,whenCreated | Select-Object SamAccountName,pwdLastSet,whenCreated | Export-Csv $logFile -NoTypeInformation -Append
    }
    else
    {
        Write-Output "[$(Get-Date -UFormat "%T")] SET-PASS: $($user.SamAccountName)" | Out-File -Append $logFile
        Set-ADAccountPassword -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $user.AccountPassword -Force)
    }
}

if ($passLastSet)
{
    "done"
}
else
{
Write-Output "[$(Get-Date -UFormat "%T")] INFO: All passwords for new accounts reset" | Out-File -Append $logFile
}
