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
    Generate list of last password change
    passwordMaintenance.ps1 -feedUsers .\feedUsers.csv -logFile .\log\resetPasswordLog20230823.log
	
	Reset users passwords...
    passwordMaintenance.ps1 -feedUsers .\feedUsers.csv -logFile .\log\resetPasswordLog20230823.log -resetPassword
#>



Param
(
    [Parameter(Position = 0, Mandatory = $true)][Object[]] $feedUsers,
    [Parameter(Position = 1, Mandatory = $false)][Switch] $resetPassword,
    [Parameter(Position = 2, Mandatory = $true)][String] $logFile
)

foreach ($user in Import-Csv -Path $feedUsers)
{
    if ($resetPassword)
    {
		Write-Output "[$(Get-Date -UFormat "%T")] SET-PASS: $($user.SamAccountName)" | Out-File -Append $logFile
        Set-ADAccountPassword -Identity $user.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $user.AccountPassword -Force)
        
    }
    else
    {
        $userInfo = Get-ADUser -Identity $user.samaccountname -Properties samaccountname,PasswordLastSet,whenCreated | Select-Object SamAccountName,PasswordLastSet,whenCreated
		$userList = $userInfo | Where-Object {($_.PasswordLastSet -lt ($_.whenCreated.AddSeconds(60)))}
		$passwordList = $userList | Select-Object SamAccountName,PasswordLastSet,whenCreated,@{name="AccountPassword"; expression={ $user.AccountPassword }}
		$passwordList | Export-Csv $logFile -NoTypeInformation -Append
    }
}

if ($passLastSet)
{
	Write-Output "[$(Get-Date -UFormat "%T")] INFO: All passwords for new accounts reset" | Out-File -Append $logFile
    
}
else
{
	"done"
}
