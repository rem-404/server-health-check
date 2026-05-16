# What does it do?
- A quick at-a-glance server status check
- The script targets multiple core Windows Domain Controllers in parallel to audit Active Directory vitals.
- It checks service statuses (NTDS / DFSR), executes native directory diagnostics (dcdiag), and checks replication status summaries (repadmin)

# What does it solve?
- It catches early replication failure
