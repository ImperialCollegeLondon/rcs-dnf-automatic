All login nodes are registered with the University Satellite service managed by the data centre team. They are also registered with insights so we (RCS) can check on their status and if any updated need to be applied.
Check https://console.redhat.com/insights/inventory and filter by "login". 
## Overview
Updates are handled using dnf-automatic but there is a custom wrapper to handle users and GPFS. This script is triggered from systemd using a service and timer. This allows log collection via *journeld* and to quickly check when the service has/will run.
## Custom script
rcs-dnf-automatic will handle users and GPFS during the update window. Users are sent a message via the wall command as the update approaches. They are then booted from the server and */etc/nologin* is put in place with a message letting the users know why they can’t connect. GPFS is shutdown and the system updated using *dnf-automatic*. Once complete, the GPFS portability layer is rebuilt to account for kernel changes and GPFS is then restarted. A few simple tests are performed before users are let back on to the node. Currently Admins are not alerted if the update fails but systemd does have an email feature that could be employed. 
## Timers
Dev and prod have different timers with the goal to try and give some testing before prod is updated. To see when the service ran and will run next use
```systemctl list-timers```


