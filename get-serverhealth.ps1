function get-serverhealth {

  Invoke-Command -ComputerName dc01, dc02 -Credential $cred -ScriptBlock {

    # Replication check
    $repl = repadmin /replsummary
    $hasFailures = $repl -match 'fails:\s+[1-9]'

    # DCDIAG check
    $dcdiag = dcdiag /q

    # DFSR service
    $dfsrService = (Get-Service DFSR).Status

    # DFSR event log check
    $dfsrErrors = Get-WinEvent -LogName "DFS Replication" -MaxEvents 50 |
    Where-Object { $_.LevelDisplayName -eq "Error" }

    $hasDFSRIssue = $dfsrErrors.Count -gt 0

    $lastDFSRIssueTime = if ($hasDFSRIssue) {
      ($dfsrErrors | Select-Object -First 1).TimeCreated
    }
    else {
      $null
    }

    [PSCustomObject]@{
      ComputerName       = $env:COMPUTERNAME
      TimeZone           = (Get-TimeZone).Id
      CurrentTime        = (Get-Date -Format "HH:mm:ss")
      LastBoot           = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
      DFSR_Service       = $dfsrService
      NTDS               = (Get-Service NTDS).Status
      ReplicationOK      = -not $hasFailures
      DCDIAG_OK          = [string]::IsNullOrWhiteSpace($dcdiag)
      DFSR_Issue         = $hasDFSRIssue
      DFSR_LastErrorTime = $lastDFSRIssueTime
    }
  }

}


