#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

                                   WEB/Internet
                                         |
                   +--------------------/ \------------------+
                   |         carp0(vr0) = 10.0.0.37          |
                   |                                         |
         10.0.0.4 vr0                                     vr0 10.0.0.5
                   |                                         |
               +-------+                    10.0.100.3   +-------+
               |  fwa  |- vr3 ---- CARP Pfsync ---- vr3 -|  fwb  |
               +-------+  10.0.100.2                     +-------+
                   |                                         |
    192.168.150.197  vr1                                       vr1 192.168.150.198
                   |                                         |
                   |         carp1(vr1) = 192.168.150.196    |
                   +--------------------\ /------------------+
                                         |
                                   Internal LAN 
                                  (192.168.150.0/24)

# - reconfigure all network interfaces

## FWA
cat <<"EOF" > /etc/hostname.vr0
up
inet 10.0.0.4 255.255.255.0
EOF

cat <<"EOF" > /etc/mygate
10.0.0.1
EOF

cat <<"EOF" > /etc/hostname.vr1
up
inet 192.168.150.197 255.255.255.0 192.168.150.255 description "openbsd install net"
EOF

cat <<"EOF" > /etc/hostname.vr3
inet 10.0.100.2 255.255.255.0 10.0.100.255 description "openbsd pfsync"
EOF

cat <<"EOF"  > /etc/hostname.pfsync0 
up syncdev vr3
EOF

pkill dhclient
sh /etc/netstart

cat <<"EOF" > /etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet.carp.preempt=1
EOF

## FWB
cat <<"EOF" > /etc/hostname.vr0
up
inet 10.0.0.5 255.255.255.0
EOF

cat <<"EOF" > /etc/mygate
10.0.0.1
EOF

cat <<"EOF" > /etc/hostname.vr1
up
inet 192.168.150.198 255.255.255.0 192.168.150.255 description "openbsd install net"
EOF

cat <<"EOF" > /etc/hostname.vr3
inet 10.0.100.3 255.255.255.0 10.0.100.255 description "openbsd pfsync"
EOF

cat <<"EOF"  > /etc/hostname.pfsync0 
up syncdev vr3
EOF

pkill dhclient
sh /etc/netstart

cat <<"EOF" > /etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet.carp.preempt=1
EOF

cat <<"EOF" > /etc/net-route.sh
#!/bin/sh

CARP0="10.0.0.37/24 description internet"
CARP1="192.168.150.196/24 description local"

function carp_master {

  echo "Configuring CARP as master..."

  sysctl -w net.inet.ip.forwarding=1

  ifconfig carp0 create
  ifconfig carp1 create
  ifconfig carp0 vhid 100 carpdev vr0 $CARP0
  ifconfig carp1 vhid 101 carpdev vr1 $CARP1
}

function carp_backup {

  echo "Configuring CARP as backup..."

  sysctl -w net.inet.ip.forwarding=1

  ifconfig carp0 create
  ifconfig carp1 create

  ifconfig carp0 vhid 100 carpdev vr0 advskew 100 $CARP0
  ifconfig carp1 vhid 101 carpdev vr1 advskew 100 $CARP1
  
}

function carp_up {

  echo "Bringing up CARP..."
  sysctl -w net.inet.ip.forwarding=1
  ifconfig carp0 up
  ifconfig carp1 up

}

function carp_down {

  echo "Bringing down CARP..."
  ifconfig carp0 down
  ifconfig carp1 down

  sysctl -w net.inet.ip.forwarding=0

}

if [ "$1" == "start-services" ]
then

  start_services

elif [ "$1" == "stop-services" ]
then

  stop_services

elif [ "$1" == "force-disable" ]
then

  stop_services

  carp_down

elif [ "$1" == "carp-up" ]
then

  carp_up

elif [ "$1" == "carp-down" ]
then

  carp_down

elif [ "$1" == "carp-master" ]
then

  carp_master

elif [ "$1" == "carp-backup" ]
then

  carp_backup

else

  echo "Script to put in standby, enable, or disable services or routing on a firewall."
  echo "CARP version."
  echo
  echo "Usage: $0 {start-services|stop-services|force-disable|carp-up|carp-down|carp-master|carp-backup}"

fi
EOF

chmod 744 /etc/net-route.sh

## FWA
sh /etc/netstart pfsync0
sh /etc/net-route.sh carp-up
sh /etc/net-route.sh carp-master

## FWB
sh /etc/netstart pfsync0
sh /etc/net-route.sh carp-up
sh /etc/net-route.sh carp-backup

# - TODO: DHCPD on vr1/carp1 + dhcrelay

