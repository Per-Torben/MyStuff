# This script lists all calendars where default permission is not free/busy only
# Written by Per-Torben Sørensen (per-torben.sorensen@advania.no)
# 
# Version: 1.0
#*********************************************************************************************
# Input values below
#
#*********************************************************************************************
# Variables below
#
$o365cred = Get-Credential -Message "Log on to Office 365"
$ExchSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $o365cred -Authentication Basic -AllowRedirection
Import-PSSession $ExchSession
$runscript = $true # Failsafe for accidental running
#*********************************************************************************************
if ($runscript -eq $false)
{Write-Host -ForegroundColor Red "Do NOT run this script non-interactively! Run from editor" 
return}
$mbx = Get-Mailbox -ResultSize unlimited
$export = @()
foreach ($mb in $mbx){
    $cal =  Get-MailboxFolderPermission -Identity "$($mb.UserPrincipalName):\calendar" | ? {$_.user -like "Default"}
    if ($cal.AccessRights -notlike "AvailabilityOnly"){
        $output = [PsCustomObject]@{
            Name                 = $mb.DisplayName
            userprincipalname    = $mb.userprincipalname
            user                 = $cal.user.UserType
            perm                 = $cal.AccessRights
            }
        $export += $output
    }
}
Write-host "The following users have different default calendar permissions:"
$export | ft
Remove-PSSession $ExchSession