# Moves recording files to a pre-determined detinationed, based n the date
#
# Written by Per-Torben Sørensen (per-torben.sorensen@advania.no)
# 
# Version: 1.0
#*********************************************************************************************
#
# Change the settings below
#
$blvsource = "G:\BlackVue\Record"
$blvdest = "E:\Onedrive\OneDrive - Sørensen IT-kompetanse\BlackVue"
#
# Variables below
#
$files = gci $blvsource
#*********************************************************************************************
# split name at "_"
foreach ($file in $files) 
{
    $foldername = $file.name -split "_"
    $path = $blvdest+"\"+$foldername[0]
    $pathexist = Test-Path $path
    if ($pathexist -eq $false)
    {
        md $path
    }
    else 
    {
    }
    if ($file.name -like "$($foldername[0])*")
    {
        Move-Item $file.FullName $path
        Write-Host "Moving $($file.FullName) to $($path)"
    }
}
# check fodler with that name - create if not existing
# move files to correct folder
