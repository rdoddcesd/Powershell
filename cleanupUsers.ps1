$users = Get-ADUser -Filter * -SearchBase "OU=Student,DC=lo,DC=loswego,DC=k12,DC=or,DC=us"
$feed = Import-Csv -Path "data\adstudents-LOSD_all.csv"
$userObjectList = @()

foreach ($user in $users) {
    $adSamAccountName = $user.SamAccountName
    $feedSamAccountName = $feed | Where-Object {$_.SamAccountName -match $adSamAccountName} | select SamAccountName
    $adCurrentOU = ($user.DistinguishedName -split ",",2)[1]
    
    if(!$feedSamAccountName[0]){
        $adSamAccountName
    }

    $currentUserObject = [PSCustomObject]@{
        adSamAccountName = $adSamAccountName
        feedSamAccountName = $feedSamAccountName
        adCurrentOU = $adCurrentOU
    }

    $userObjectList += $currentUserObject
}

$userObjectList | Export-Csv -Path "C:\temp\verifyUserData-report.csv" -NoTypeInformation

#$users.count
#$filter.count
