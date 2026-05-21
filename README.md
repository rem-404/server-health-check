# Get-ServerHealth
Proof of concept — also just existing here.


# What does it do?
Runs a multi-point health check against your Domain Controllers remotely and returns a 
consolidated snapshot of each DC's current state in a single function call.

# What does it solve?
Manually checking Domain Controllers is tedious.
This script consolidates all of that into a single remote call across DCs simultaneously, giving you a quick at-a-glance Server Status

## Useful for:
- Morning health checks before the day starts
- Quick sanity check after a reboot or patch cycle
- Spotting replication or DFSR issues before they become user-impacting problems

# Who's it for?
Sysadmins managing a Windows Active Directory environment with at least two Domain Controllers who want a fast, 
no-RDP-required health snapshot — especially useful in a homelab or small AD environment where you wear all the hats.

# Requirements
- PowerShell 5.1+ 
- A credential object stored in $cred

# Limitations
DC hostnames (dc01, dc02) are hardcoded — update them to match your environment, or extend it to pull from AD dynamically
dcdiag /q only suppresses passing tests; any output is treated as a failure — which is the right behavior, but noisy if your environment has known/accepted warnings
DFSR event log check only looks at the last 50 events — adjust -MaxEvents for deeper history
$cred must be defined before calling the function
