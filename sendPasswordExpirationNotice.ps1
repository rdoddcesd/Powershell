<#
.SYNOPSIS
    Name: sendPasswordExpirationNotice.ps1
    Sends email notifing user that there password will expire in X days.
.DESCRIPTION
    Sends email notifing user that there password will expire in X days. X can be defined using the passAge parameter.
.PARAMETER passAge
    Numaric value representing the age of passwords to find. IE. a value of 360 will return all users that have a password set 360 days ago or longer.
.PARAMETER targetOU
	Target OU DN to search users.
.NOTES
    Release Date: Nov 6th, 2023
   
    Author:
    Ryan Dodd - Systems Infrastructure Engineer II
    Clackamas Education Service District - Technology Services
    rdodd@clackesd.k12.or.us
.EXAMPLE
    sendPasswordExpirationNotice.ps1 -passAge 360 -targetOU "OU=Staff,DC=district,DC=k12,DC=or,DC=us"
#>

Param
(
    [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Password age to search, positive value up to 365.")][ValidateRange(0,365)][Int] $passAge,
    [Parameter(Mandatory = $true, HelpMessage = "OU of users to target.")][string] $targetOU
)

$userList = Get-ADUser -Filter 'Enabled -eq $True' -SearchBase $targetOU -Properties PasswordLastSet,mail | Where-Object {$_.PasswordLastSet -lt (Get-Date).adddays(-$passAge) -and $_.mail -ne $null} | Select-Object Name,SamAccountName,mail,PasswordLastSet

$From = "no-reply@district.k12.or.us"
$To = "password-alerts@district.k12.or.us"
$Bcc = $userList.mail
$Subject = "Password Expiration Notice"
$Body = "Your password will expire soon. Please change it immediately by logging into https://myaccount.microsoft.com/ and click change password. "
$SMTPServer = "aspmx.l.google.com"
Send-MailMessage -From $From -To $To -Bcc $Bcc -Subject $Subject -Body $Body -SmtpServer $SMTPServer
