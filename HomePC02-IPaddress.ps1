# This script checks and corrects local IP setting
# Written by Per-Torben Sørensen (per-torben.sorensen@advania.no)
# 
# Version: 1.0
#*********************************************************************************************
# Input values below
#
$nic = "vEthernet (External Virtual Switch)"
#*********************************************************************************************
#
# Variables below
#
$ipcfg = Get-NetIPConfiguration -InterfaceAlias $nic
$runscript = $true # Failsafe for accidental running
#*********************************************************************************************
if ($runscript -eq $false)
{Write-Host -ForegroundColor Red "Do NOT run this script non-interactively! Run from editor" 
return}
if ($ipcfg.IPv4Address.ipaddress -ne "172.17.2.12") 
    {
    $IPisOK = $true
    }
ELSE
    {
    $IPisOK = $false
    }    
$VPNisOK = (Test-NetConnection homedc06).pingsucceeded
IF ($IPisOK = $false)    
    {
    Write-Host -ForegroundColor Red -BackgroundColor Black "IP is $($ipcfg.IPv4Address.ipaddress). Changing this"
    New-NetIPAddress -InterfaceAlias $nic -IPAddress "172.17.2.12" -PrefixLength 25 -DefaultGateway "172.17.2.126" 
    Set-DnsClientServerAddress -InterfaceAlias $nic -ServerAddresses 172.17.2.5, 172.17.1.4
    Ipconfig /registerdns
    }
ELSE
    {
    Write-Host -ForegroundColor Green -BackgroundColor Black "IP is $($ipcfg.IPv4Address.ipaddress). All is good"
    }
IF ($VPNisOK -eq $false)
    {
    Write-Host -ForegroundColor Red -BackgroundColor Black "VPN to Azure is down! Please check!"
    }
ELSE
    {
    Write-Host -ForegroundColor Green -BackgroundColor Black "VPN is connected to Azure. All is good"
    }
pause