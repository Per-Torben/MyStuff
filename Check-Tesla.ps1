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
$securefile = $env:userprofile+"\documents\$($teslapwdfile)" # Encrypted passwordfile for the user
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

$token = Get-TeslaToken -Credential $teslacred

$vehicle = Get-TeslaVehicle -Token $token




($token.access_token).GetType()
$crypttoken = $token.access_token 
$crypttoken

$tokencred = new-object -typename System.Management.Automation.PSCredential -argumentlist $crypttoken

([DateTimeOffset](Get-Date)).ToUnixTimeSeconds()
$token.created_at
$origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
$whatIWant = $origin.AddSeconds($token.created_at)
$expire = $whatIWant.AddSeconds($token.expires_in)
IF ((Get-Date) -gt $expire) {
    $true
}

<#
1. Securestring av token
2. Konvertere dato/tidspunkt - gyldig for hvor lenge?
3. Lagre kryptert token og gyldig tid
4. Github med 2 faktor
#>

<#
$teslatoken = [PsCustomObject]@{
    $accesstoken = ($token.access_token | ConvertTo-SecureString)
    $expire = $token.expires_in
}
#>