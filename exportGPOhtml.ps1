param (
    [parameter(Mandatory = $true)]
    [String[]]$Domian,
    [parameter(Mandatory = $true)]
    [String]$ExportPath
)
$Results = @()

$AllGpos = Get-GPO -All -Domain $domain

# create paths
mkdir $ExportPath
$gpoExportPath = $ExportPath + "\GPOs"
mkdir $gpoExportPath

foreach ($Gpo in $AllGpos) {

## export HTML
$gpoName = $gpo.DisplayName
$gpoExportHTML = $gpoExportPath + "\$gpoName.html"
Get-GPOReport -Name $Gpo.DisplayName -ReportType HTML -Path $gpoExportHTML

## create table for properties
$properties = @{
    GPO_Name = $gpo.DisplayName
    Created = $gpo.CreationTime
    Last_Modified = $gpo.ModificationTime
    GPO_Status = $gpo.GpoStatus
}

## results to variable 
$Results += New-Object psobject -Property $properties
}

## export resutls
$Results | Select-Object GPO_Name,Created,Last_Modified,GPO_Status | Export-Csv -Path $ExportPath\GPOReport.csv -NoTypeInformation
