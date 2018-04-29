# Sample codes

# Download AAD-Connect
#
$source = "https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi"
$destination = $env:userprofile+"\downloads\AzureADConnect.msi"
Start-BitsTransfer -Source $source -Destination $destination
Write-Host "AAD Connect is stored at $($destination)"

# Install azure modules 
#
install-module msonline
install-module azurerm
Install-Module azureAD

# Building cred with encrypted file
#
$onlineusername = "root@migratelab2017b.onmicrosoft.com"
$securefile = "c:\windows\temp\securecred.txt" # Encrypted passwordfile for the user
IF ((test-path $securefile) -eq $false)
{
    read-host -assecurestring -Prompt "Log on as $($onlineusername)"| convertfrom-securestring | out-file $securefile # Set securestring with password - only need to run interactively once
}
$pass = cat $securefile | convertto-securestring # Building credential
$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist $onlineusername,$pass # Building credential

# Connect msol
#
Connect-MsolService -Credential $mycred

# Connect Exchange online
#
$ExchSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $mycred -Authentication Basic -AllowRedirection
Import-PSSession $ExchSession

# Connect AzureAD
#
Connect-AzureAD -Credential $mycred

# Creates file on 1 MB
#
$file = [System.IO.File]::Create('c:\windows\temp\labfile.txt')
$file.SetLength(1mb)
$file.Close()
Get-Item $file.Name

# Send 10 mails with attachments from powershell
#
$userid='root@migratelab2017b.onmicrosoft.com'
$creds=Get-Credential $userid
$i = 1
while ($i -le 10)
{
    Send-MailMessage `
    -To 'ned.stark@migrate.sorensen.ws' `
    -Subject "Testmail $($i)" `
    -Body 'This is just to fill up your mailbox' `
    -UseSsl `
    -Port 587 `
    -SmtpServer 'smtp.office365.com' `
    -From $userid `
    -Credential $creds
    -Attachments $file.Name
    $i=$i+1
}