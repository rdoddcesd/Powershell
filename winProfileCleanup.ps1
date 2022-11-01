#The following line needs to be ran localy to get a list of local user profiles and there associated SID
#gwmi win32_userprofile | select localpath, sid | Export-Csv -NoTypeInformation userprofiles.csv
$localProfile = Import-Csv <PATH TO CSV CONTAINING SID>

foreach($profile in $localProfile) {
    $sid = $profile.sid
    Get-ADUser -Filter {SID -eq $sid} | Select-Object -Property SID,SamAccountName
}
