#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

## FWA
cat <<"EOF" > /home/fa1c0n/startup_config.sh
#!/bin/sh
/etc/netstart pfsync0
/etc/net-route.sh carp-up
/etc/net-route.sh carp-master
exit 1
EOF

chmod +x /home/fa1c0n/startup_config.sh
crontab -e
@reboot /home/fa1c0n/startup_config.sh

## FWB
cat <<"EOF" > /home/fa1c0n/startup_config.sh
#!/bin/sh
/etc/netstart pfsync0
/etc/net-route.sh carp-up
/etc/net-route.sh carp-backup
exit 1
EOF

chmod +x /home/fa1c0n/startup_config.sh
crontab -e
@reboot /home/fa1c0n/startup_config.sh

