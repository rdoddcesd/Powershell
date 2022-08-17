# Use the following command to list profiles
#   netsh wlan show profiles
# Choose the profile you want to export and a location to export the file to:
#   netsh wlan export profile name="Ryan" folder="c:\wireless-profile" 

# example, .\addWifiProfile.ps1 -ssid Ryan -profile C:\temp\Wi-Fi-Ryan.xml

param 
    (
        [Parameter(Mandatory=$true)] $ssid,
        [Parameter(Mandatory=$true)] $profile
    )

netsh wlan add profile filename=$profile user=all
netsh wlan set profileparameter name=$ssid connectionmode=auto
