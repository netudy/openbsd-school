#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Configure firewalll and NAT
##########################################################

cat <<"EOF" > /etc/hostname
console
EOF

# reconfigure to be trunk port

# dhcp
cat <<"EOF" > /etc/hostname.vr0
up
EOF

cat <<"EOF" > /etc/hostname.vr1
up
EOF

cat <<"EOF" > /etc/hostname.trunk0
trunkproto failover trunkport vr0 trunkport vr1
dhcp
EOF

sh /etc/netstart
