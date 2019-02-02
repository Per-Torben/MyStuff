<# 
This script connects to your Tesla car and retrieves information
Written by Per-Torben Sørensen (per-torben.sorensen@advania.no)
*********************************************************************************************
Input values below
#>
$username = "per-torben@sorensen.ws"
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
$export = @()
while ($true) {
    $time = (Get-Date -UFormat %Y.%m.%d_%H.%M.%S)
    $range = Get-TeslaVehicleChargeState -Vehicle $vehicle -Token $token
    $car = Get-TeslaVehicleDriveState -Vehicle $vehicle -Token $token
    $climate = Get-TeslaVehicleClimateState -Token $token -Vehicle $vehicle
    $output = [PsCustomObject]@{
        Time               = $time
        Percent            = $range.battery_level
        Typical            = ($range.ideal_battery_range*1.6)
        Estimated          = ($range.est_battery_range*1.6)
        BatteryRange       = ($range.battery_range*1.6)
        Gear               = $car.shift_state
        Speed              = ($car.speed*1.6)
        Power              = $range.charger_power
        Rate               = $range.charge_rate
        CliBatteryheater   = $climate.battery_heater
        Batteryheater      = $range.battery_heater_on
        CannotHeat         = $range.not_enough_power_to_heat
        }
    $output
    $export += $output
    #write-host "Sleeping 2 hours..."
    sleep 30
}
$export |select Time, Percent, Typical, Estimated, BatteryRange, Gear, Speed, Power, Rate, Batteryheater, CannotHeat | ft |Export-Csv "C:\Users\per-torben\OneDrive\Privat\Tesla\Charge-range-$($time).csv" -Encoding UTF8 -Delimiter ";" -Append -NoTypeInformation

<#
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
