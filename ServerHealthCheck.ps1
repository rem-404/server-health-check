# A simple server health check to catch some minor issues before it cause a larger headache
# be sure to check the credential
Invoke-Command -ComputerName dc01,dc02 -Credential $cred -ScriptBlock {

    $repl = repadmin /replsummary
    $hasFailures = $repl -match 'fails:\s+[1-9]'

    $dcdiag = dcdiag /q

    [PSCustomObject]@{
        ComputerName     = $env:COMPUTERNAME
        TimeZone         = (Get-TimeZone).Id
        CurrentTime      = (Get-Date -Format "HH:mm:ss")
        LastBoot         = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        DFSR             = (Get-Service DFSR).Status
        NTDS             = (Get-Service NTDS).Status
        ReplicationOK    = -not $hasFailures
        DCDIAG_OK        = [string]::IsNullOrWhiteSpace($dcdiag)
    }
# The out-file can be remove to output the result directly on the screen
} | convertto-json | Out-File -path 'c:\logs\v2Health.json'