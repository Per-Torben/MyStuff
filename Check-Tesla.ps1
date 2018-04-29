<# 
This script connects to your Tesla car and retrieves information
Written by Per-Torben Sørensen (per-torben.sorensen@advania.no)
*********************************************************************************************
Input values below
#>
$username = "per-torben@sorensen.ws"
$tokenfile = "teslatoken.json"
$teslapwdfile = "teslapwd.txt"
<#*********************************************************************************************
 Variables below
#>
$securefile = ".\$($teslapwdfile)" # Encrypted passwordfile for the user
IF ((test-path $securefile) -eq $false) {
    read-host -assecurestring -Prompt "Log on as $($username)"| convertfrom-securestring | out-file $securefile # Set securestring with password - only need to run interactively once
}
$pass = cat $securefile | convertto-securestring # Building credential
$teslacred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $pass # Building credential
$runscript = $false # Failsafe for accidental running
#*********************************************************************************************
if ($runscript -eq $false) {
    Write-Host -ForegroundColor Red "Do NOT run this script non-interactively! Run from editor"
    Start-Sleep 10
    #return
}
#*********************************************************************************************
Import-Module tesla
