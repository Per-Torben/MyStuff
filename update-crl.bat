robocopy c:\windows\system32\certsrv\certenroll\ c:\crl
"C:\Program Files (x86)\WinSCP\winscp.com" /command ^
    "open ftp://crl\teslarangeftp:Oppstih8@waws-prod-am2-163.ftp.azurewebsites.windows.net/" ^
    "put C:\crl\* /site/wwwroot/" ^
    "exit"
