#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# - init DHCPD and TFTP OpenBSD 7.2
##########################################################

dhcpd vr1

# - confirm dhcpd is up and running
ps aux | grep dhcpd
# _dhcp    81938  0.0  0.2   772  1280 ??  Ipc     5:32PM    0:00.01 dhcpd vr1
# root     97992  0.0  0.2   492  1272 p0  S+p     5:33PM    0:00.02 grep dhcpd

# - configure tftpd

mkdir -p /usr/local/tftp
tftpd -4 -v -l 192.168.150.197 /usr/local/tftp

# - confirm tftpd is up and running
ps aux | grep tftpd
# _tftpd   55182  0.0  0.2   644   916 ??  Sp      5:33PM    0:00.00 tftpd -4 -v -l 192.168.150.197 /usr/local/tftp
# root     18579  0.0  0.2   488  1264 p0  S+p     5:33PM    0:00.02 grep tftpd

