$smtpcred = (Get-Credential)
<#
$toaddress = 'edig-adminpts@edigardas.onmicrosoft.com'
$fromaddress = 'edig-adminpts@edigardas.onmicrosoft.com'
$smtpserver = 'smtp.office365.com'
$smtpport = '587'
$attachment = ''

$mail = @{
    To         = $toaddress
    From       = $fromaddress
    Subject    = 'Test message'
    Body       = 'This is a test mail from Powershell'
    smtpserver = $smtpserver
    Port       = $smtpport
    Credential = $smtpcred
    
}
Send-MailMessage @mail -UseSsl
#>