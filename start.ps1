function StopProcessByPort {
    param (
        [int] $port
    )

    $processPID = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if($processPID -ne $Null) {
        Stop-Process -Id ($processPID).OwningProcess -Force 
    }
}

Write-Host "Kill previous start"

StopProcessByPort 5000
StopProcessByPort 6000
StopProcessByPort 7000
StopProcessByPort 8000

Write-Host "Start services"

Start-Process -NoNewWindow -FilePath 'dotnet' -ArgumentList 'run --project ./First/First.csproj'
Start-Process -NoNewWindow -FilePath 'dotnet' -ArgumentList 'run --project ./Second/Second.csproj'
Start-Process -NoNewWindow -FilePath 'dotnet' -ArgumentList 'run --project ./Third/Third.csproj'
$env:GO111MODULE="on"
Start-Process -NoNewWindow powershell 'go run ./alien/alien.go'