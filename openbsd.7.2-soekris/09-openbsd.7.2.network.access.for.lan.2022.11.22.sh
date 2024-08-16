#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

## FWA
cat <<"EOF" > /etc/pf.conf
#   $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
#
# See pf.conf(5) and /etc/examples/pf.conf

set skip on lo

block return    # block stateless traffic
pass        # establish keep-state

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild

match out on egress inet from !(egress) to any nat-to (egress:0)

# Internal services and traffic
pass quick on vr1 no state
EOF

cat <<"EOF" > /etc/hostname.vr0
up
inet 10.0.0.4 255.255.255.0
EOF
chmod 600 /etc/hostname.vr0
sh /etc/netstart vr0

cat <<"EOF" > /etc/hostname.vr1
up
inet 192.168.150.197 255.255.255.0 192.168.150.255 description "openbsd install net"
EOF

chmod 600 /etc/hostname.vr1
sh /etc/netstart vr1

cat <<"EOF" > /etc/dhcpd.conf
option  domain-name "2226.local";
option  domain-name-servers 1.1.1.1;

subnet 192.168.150.0 netmask 255.255.255.0 {
    option routers 192.168.150.197;

    range 192.168.150.202 192.168.150.225;

    filename "pxeboot";

# host fwa {
#     hardware ethernet 02:03:04:05:06:07;
#     filename "pxeboot";
#     next-server 192.168.150.201;
# }
}
EOF
/usr/sbin/dhcpd -y vr3 -Y vr3 vr1
# Listening on vr1 (192.168.150.197).
pgrep dhcpd
# 6865

## FWB
cat <<"EOF" > /etc/pf.conf
#   $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
#
# See pf.conf(5) and /etc/examples/pf.conf

set skip on lo

block return    # block stateless traffic
pass        # establish keep-state

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild

match out on egress inet from !(egress) to any nat-to (egress:0)

# Internal services and traffic
pass quick on vr1 no state
EOF

cat <<"EOF" > /etc/hostname.vr0
up
inet 10.0.0.5 255.255.255.0
EOF
chmod 600 /etc/hostname.vr0
sh /etc/netstart vr0

cat <<"EOF" > /etc/hostname.vr1
up
inet 192.168.150.198 255.255.255.0 192.168.150.255 description "openbsd install net"
EOF

chmod 600 /etc/hostname.vr1
sh /etc/netstart vr1

cat <<"EOF" > /etc/dhcpd.conf
option  domain-name "2226.local";
option  domain-name-servers 1.1.1.1;

subnet 192.168.150.0 netmask 255.255.255.0 {
    option routers 192.168.150.198;

    range 192.168.150.226 192.168.150.250;

    filename "pxeboot";

# host fwa {
#     hardware ethernet 02:03:04:05:06:07;
#     filename "pxeboot";
#     next-server 192.168.150.201;
# }
}
EOF

cat <<"EOF" > /etc/rc.conf.local
pkg_scripts=nginx
dhcpd_flags=""
EOF
/usr/sbin/dhcpd -y vr3 -Y vr3 vr1
# Listening on vr1 (192.168.150.198).
pgrep dhcpd
# 18246

## FWA
sh /etc/netstart pfsync0
sh /etc/net-route.sh carp-up
sh /etc/net-route.sh carp-master

## FWB
sh /etc/netstart pfsync0
sh /etc/net-route.sh carp-up
sh /etc/net-route.sh carp-backup

# - TODO: net-route.sh on startup
