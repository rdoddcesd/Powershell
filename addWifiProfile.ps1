# Use the following command to list profiles
#   netsh wlan show profiles
# Choose the profile you want to export and a location to export the file to:
#   netsh wlan export profile name="Ryan" folder="c:\wireless-profile" 
# Place wifi profile XML file in SYSVOL
# Path to wifi profile XML
$prof = "C:\temp\Wi-Fi-Ryan.xml"
# SSID
$name = "Ryan"

netsh wlan add profile filename=$prof user=all
netsh wlan set profileparameter name=$name connectionmode=auto
