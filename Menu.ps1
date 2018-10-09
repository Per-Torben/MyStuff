function Show-Menu {
    param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for this option."
    Write-Host "2: Press '2' for this option."
    Write-Host "3: Press '3' for this option."
    Write-Host "Q: Press 'Q' to quit."
}
$selection = Read-Host "choose"

do {
    Show-Menu -Title "New title"
    $selection = Read-Host "choose"
    switch ($selection) {
        '1' {
            'You chose 1'
        }
        '2' {
            'You chose 2'
        }
        '3' {
            'You chose 3'
        }
    }
    start-sleep 3
}
until ($selection -eq 'q')
