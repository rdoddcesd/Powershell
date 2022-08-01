<#
.SYNOPSIS
    Name: forcePWchange.ps1
    This script is used to force user password change on next login via Active Directory.

.DESCRIPTION
    Script automates checking the "User must changed password on next login". Active directory does not allow checking "User must changed password on next login" and
    "Password never expires" via Set-ADUser. You can check both "User must changed password on next login" and "User cannot change password" using Set-ADUser, this
    results in the user being unable to log in. To solve these problems we uncheck both "Password never expires" and "User cannot change password". A log is created
    to note what was checked prior to changing.

.PARAMETER OU
    Full distinguishedName of Org Unit to make change to. Sciprt runs recursivly, thus all nested OUs will be impacted as well.

.NOTES
    Version: 1.0
    Updated: 
    Release Date: June 13th, 2022
   
    Author: 
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology
    rdodd@clackesd.k12.or.us

.EXAMPLE
    .\forcePWchange.ps1 "OU=Nested Test Accounts,OU=Test Accounts,OU=Users,OU=CESD,DC=techdev,DC=clackesd,DC=k12,DC=or,DC=us"
#>

Param
(
    [Parameter(Mandatory = $true, HelpMessage = "Full DN of the OU being restarted")][string] $OU
)

$compareDateTime = $(get-date).AddDays(-8)
$users = Get-ADUser -SearchBase $OU -Filter * -Properties CannotChangePassword,PasswordNeverExpires,pwdLastSet,passwordLastSet | where { $_.passwordLastSet -lt $compareDateTime }
$userObjectList = @()

foreach ($user in $users)
    {
        $currentUserObject = [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            CannotChangePassword = $user.CannotChangePassword
            PasswordNeverExpires = $user.PasswordNeverExpires
            PasswordLastSet = $user.passwordLastSet
        }


        $userObjectList += $currentUserObject

        #Set-ADUser -Identity $user -ChangePasswordAtLogon $True -CannotChangePassword $False -PasswordNeverExpires $False
    }

$userObjectList | Export-Csv -NoTypeInformation ".\$((Get-Date).ToString("yyyyMMdd_HHmmss"))_forcePWchangeLog.csv"
