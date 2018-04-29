# Math game
#
$rounds = Read-host -prompt "Hvor mange oppgaver vil du ha?"
$range = 1..10
while ($rounds -notlike 0){
    $a = $range | Get-Random
    $b = $range | Get-Random
    $question = $a*$b
    Write-Host "Hva er $($a) ganger $($b) ?"
    $answer = Read-Host "Skriv inn svaret og trykk Enter"
    IF ($answer -eq $question){
        Write-Host -ForegroundColor Green "RIKTIG"
    }
    ELSE {
        Write-host -ForegroundColor Red "FEIL"
    }
    $rounds = $rounds-1
}


