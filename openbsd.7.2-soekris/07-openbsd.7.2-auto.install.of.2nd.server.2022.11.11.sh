#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Prepare FWA
##########################################################
# - on your OSX or Ubuntu connect via serial

cu -s 19200 -l /dev/tty.usbserial
# Connected.

# just in case

cat <<"EOF" > /etc/hostname.vr0
up
dhcp
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

    range 192.168.150.200 192.168.150.250;

    filename "pxeboot";

# host fwa {
#     hardware ethernet 02:03:04:05:06:07;
#     filename "pxeboot";
#     next-server 192.168.150.201;
# }
}
EOF
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

chmod 775 /usr/local/tftp

cd /usr/local/tftp/
wget --no-check-certificate https://ftp.eu.openbsd.org/pub/OpenBSD/7.2/i386/pxeboot
wget --no-check-certificate https://ftp.eu.openbsd.org/pub/OpenBSD/7.2/i386/bsd
wget --no-check-certificate https://ftp.eu.openbsd.org/pub/OpenBSD/7.2/i386/bsd.rd

# cp pxeboot pxeboo
mkdir -p /usr/local/tftp/etc
cat <<"EOF" > /usr/local/tftp/etc/boot.conf
set tty com0
stty com0 19200
boot tftp:/bsd.rd
EOF

# Basic pf config 
# - add rules: NAT:ing internal traffic on vr1, outgoing via vr0
# - add rules: simplify internal traffic on vr1, by skipping session tables

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

sysctl -w net.inet.ip.forwarding=1
# net.inet.ip.forwarding: 0 -> 1
sysctl -w net.inet.carp.preempt=1
# net.inet.carp.preempt: 0 -> 1
pfctl -f /etc/pf.conf

##########################################################
# Autoinstall configuration for OpenBSD
##########################################################
# https://man.openbsd.org/autoinstall.8
# http://eradman.com/posts/autoinstall-openbsd.html
# - produce file http://192.168.150.197/install.conf

# - on FWA (DHCPD/TFTPD server)
export PKG_PATH=http://ftp.eu.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/
pkg_add nginx
# quirks-2.114 signed on 2015-08-09T15:30:39Z
# Ambiguous: choose package for nginx
# a       0: <None>
#         1: nginx-1.9.3p3
#         2: nginx-1.9.3p3-lua
#         3: nginx-1.9.3p3-naxsi
#         4: nginx-1.9.3p3-passenger
Your choice: "1"
# nginx-1.9.3p3: ok
# The following new rcscripts were installed: /etc/rc.d/nginx
# See rcctl(8) for details.
# Look in /usr/local/share/doc/pkg-readmes for extra documentation.

rcctl set nginx status on
rcctl enable nginx
rcctl start nginx

# - get root hash and create install.conf 

cat /etc/master.passwd | grep root:/bin
# root:$2b$07$7QazULeWerMDf9WXFNyXB.60UlBvQ9gYAUHnYSNw8xomVs5vV5i/a:0:0:daemon:0:0:Charlie &:/root:/bin/ksh

cat <<"EOF" > /var/www/htdocs/install.conf
System hostname = fwb
Network interfaces = vr0
IPv4 address for vr0 = dhcp
Password for root = $2b$07$7QazULeWerMDf9WXFNyXB.60UlBvQ9gYAUHnYSNw8xomVs5vV5i/a
Change the default console to com0 = yes
Which speed should com0 use = 19200
Setup a user = fa1c0n
Password for user = *************
Public ssh key for user = ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJZR86R1Q5ralftKKAuhrWNvKfBfg1SsXsqko1MdT9N1OpkyUr5ROl9tV/AoA6Em+uuRlpWxYlWF4tD09C6YSh8wHjbkXc6tA8VAWbiz+eXC4lAKCjYafwXHeFaluNwqZzev7PflueH3VHhqOFmwHGmYgqC7jMxC4YSSnbSNSjITH4CKHrckXH6ly33aXe1TdP0PZ7+EUKWmgGrhKr+765OjpNESkn6l+mT1/cpz5Vy9Fea7x0FfeoNn6T4N1zaLqRWCuOG91GiT3Nhd1irzATT3HA28XAOlxm87Clz6aNFYwYdwopDY0RIJCyZ1D4Zq/zWKbAwbIeGZrbD7xhdtLYA59+v/Ft7odcrRShhuRplV3wMgx8Cwb6XOLyyeKIjh0+MUBrBl+LfQSwu74ZMANukAA4NB0iApoYyQDhc4ea/qgnOPXtdeKjAB/2E0MKbtXvQ+w2TaBMErngXi4GHMKSd7KsWtivHEvLU/x1Oupjf+PXOkrGfeAwvqegwkBh5i8= fa1c0n@fa1c0n
Start sshd(8) by default = yes
What timezone are you in = Europe/Stockholm
Unable to connect using https. Use http instead = yes
Location of sets = http
Set name(s) = -all bsd* base* etc* man* site* comp*
HTTP Server = ftp.eu.openbsd.org
URL to autopartitioning template for disklabel = http://192.168.150.197/openbsd-pgdb.disklabel
Cannot determine prefetch area. Continue without verification? = yes
EOF

cat <<"EOF" > /var/www/htdocs/openbsd-pgdb.disklabel
/           1953M
EOF

DEST=/var/www/htdocs
ls -lt ${DEST} >${DEST}/index.txt

##########################################################
# Use FWB to re-install FWA using DHCPD and TFTPD
##########################################################
# Cabling:
# FW-B-em0 <===> home-router
# FW-A-em0 <===> FW-B-vr1

# - power on the soekris

# POST: 012345689bcefghips1234ajklnopqr,,,tvwxy








# comBIOS ver. 1.33  20070103  Copyright (C) 2000-2007 Soekris Engineering.

# net5501

# 0512 Mbyte Memory                        CPU Geode LX 500 Mhz

# Pri Mas  SanDisk SDCFH2-002G             LBA Xlt 992-64-63  2001 Mbyte

# Slot   Vend Dev  ClassRev Cmd  Stat CL LT HT  Base1    Base2   Int
# -------------------------------------------------------------------
# 0:01:2 1022 2082 10100000 0006 0220 08 00 00 A0000000 00000000 10
# 0:06:0 1106 3053 02000096 0117 0210 08 40 00 0000E101 A0004000 11
# 0:07:0 1106 3053 02000096 0117 0210 08 40 00 0000E201 A0004100 05
# 0:08:0 1106 3053 02000096 0117 0210 08 40 00 0000E301 A0004200 09
# 0:09:0 1106 3053 02000096 0117 0210 08 40 00 0000E401 A0004300 12
# 0:20:0 1022 2090 06010003 0009 02A0 08 40 80 00006001 00006101
# 0:20:2 1022 209A 01018001 0005 02A0 08 00 00 00000000 00000000
# 0:21:0 1022 2094 0C031002 0006 0230 08 00 80 A0005000 00000000 15
# 0:21:1 1022 2095 0C032002 0006 0230 08 00 00 A0006000 00000000 15

#  5 Seconds to automatic boot.   Press Ctrl-P for entering Monitor.

# comBIOS Monitor.   Press ? for help.

> boot f0

# Intel UNDI, PXE-2.0 (build 082)
# Copyright (C) 1997,1998,1999  Intel Corporation
# VIA Rhine III Management Adapter v2.43 (2005/12/15)

# CLIENT MAC ADDR: 00 00 24 CA 68 10
# CLIENT IP: 192.168.150.200  MASK: 255.255.255.0  DHCP IP: 192.168.150.197
# GATEWAY IP: 192.168.150.197
# probing: pc0 com0 com1 pxe![2.1] mem[639K 511M a20=on]
# disk: hd0+
# net: mac 00:00:24:ca:68:10, ip 192.168.150.200, server 192.168.150.197
# >> OpenBSD/i386 PXEBOOT 3.44
# switching console to com0��fx��`����ff�����`f�x�`�����~�����~f��~��fxfx~�����x�ff~`�������fx��`��������~fx���f��~f��f�����~����f~��~
# com0: 19200 baud
# booting tftp:/bsd.rd: 3267095+1438720+4366344+0+417792 [88+160+28]=0x90f300
# entry point at 0x201000

# Copyright (c) 1982, 1986, 1989, 1991, 1993
#         The Regents of the University of California.  All rights reserved.
# Copyright (c) 1995-2022 OpenBSD. All rights reserved.  https://www.OpenBSD.org

# OpenBSD 7.2 (RAMDISK_CD) #378: Tue Sep 27 13:05:38 MDT 2022
#     deraadt@i386.openbsd.org:/usr/src/sys/arch/i386/compile/RAMDISK_CD
# real mem  = 536408064 (511MB)
# avail mem = 516382720 (492MB)
# random: good seed from bootblocks
# mainbus0 at root
# bios0 at mainbus0: date 20/70/03, BIOS32 rev. 0 @ 0xfac40
# pcibios0 at bios0: rev 2.0 @ 0xf0000/0x10000
# pcibios0: pcibios_get_intr_routing - function not supported
# pcibios0: PCI IRQ Routing information unavailable.
# pcibios0: PCI bus #0 is the last bus
# bios0: ROM list: 0xc8000/0xa800
# cpu0 at mainbus0: (uniprocessor)
# cpu0: Geode(TM) Integrated Processor by AMD PCS ("AuthenticAMD" 586-class) 500 MHz, 05-0a-02
# cpu0: FPU,DE,PSE,TSC,MSR,CX8,SEP,PGE,CMOV,CFLUSH,MMX,MMXX,3DNOW2,3DNOW
# pci0 at mainbus0 bus 0: configuration mode 1 (no bios)
# 0:20:0: io address conflict 0x6100/0x100
# 0:20:0: io address conflict 0x6200/0x200
# pchb0 at pci0 dev 1 function 0 "AMD Geode LX" rev 0x31
# "AMD Geode LX Crypto" rev 0x00 at pci0 dev 1 function 2 not configured
# vr0 at pci0 dev 6 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 11, address 00:00:24:ca:68:10
# ukphy0 at vr0 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr1 at pci0 dev 7 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 5, address 00:00:24:ca:68:11
# ukphy1 at vr1 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr2 at pci0 dev 8 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 9, address 00:00:24:ca:68:12
# ukphy2 at vr2 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr3 at pci0 dev 9 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 12, address 00:00:24:ca:68:13
# ukphy3 at vr3 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# pcib0 at pci0 dev 20 function 0 "AMD CS5536 ISA" rev 0x03
# pciide0 at pci0 dev 20 function 2 "AMD CS5536 IDE" rev 0x01: DMA, channel 0 wired to compatibility, channel 1 wired to compatibility
# wd0 at pciide0 channel 0 drive 0: <SanDisk SDCFH2-002G>
# wd0: 4-sector PIO, LBA, 1953MB, 4001760 sectors
# wd0(pciide0:0:0): using PIO mode 4, DMA mode 2
# pciide0: channel 1 ignored (disabled)
# ohci0 at pci0 dev 21 function 0 "AMD CS5536 USB" rev 0x02: irq 15, version 1.0, legacy support
# ehci0 at pci0 dev 21 function 1 "AMD CS5536 USB" rev 0x02: irq 15
# usb0 at ehci0: USB revision 2.0
# uhub0 at usb0 configuration 1 interface 0 "AMD EHCI root hub" rev 2.00/1.00 addr 1
# isa0 at pcib0
# isadma0 at isa0
# com0 at isa0 port 0x3f8/8 irq 4: ns16550a, 16 byte fifo
# com0: console
# com1 at isa0 port 0x2f8/8 irq 3: ns16550a, 16 byte fifo
# pckbc0 at isa0 port 0x60/5 irq 1 irq 12
# pckbc0: unable to establish interrupt for irq 12
# pckbd0 at pckbc0 (kbd slot)
# wskbd0 at pckbd0: console keyboard
# npx0 at isa0 port 0xf0/16: reported by CPUID; using exception 16
# usb1 at ohci0: USB revision 1.0
# uhub1 at usb1 configuration 1 interface 0 "AMD OHCI root hub" rev 1.00/1.00 addr 1
# softraid0 at root
# scsibus0 at softraid0: 256 targets
# PXE boot MAC address 00:00:24:ca:68:10, interface vr0
# root on rd0a swap on rd0b dump on rd0b
# WARNING: CHECK AND RESET THE DATE!
# erase ^?, werase ^W, kill ^U, intr ^C, status ^T

# Welcome to the OpenBSD/i386 7.2 installation program.
# Starting non-interactive mode in 5 seconds...
# (I)nstall, (U)pgrade, (A)utoinstall or (S)hell?
# Could not determine auto mode.
# Response file location? [http://192.168.150.197/install.conf]
# Fetching http://192.168.150.197/install.conf
# Performing non-interactive install...
# Terminal type? [vt220] vt220
# System hostname? (short form, e.g. 'foo') fwb

# Available network interfaces are: vr0 vr1 vr2 vr3 vlan0.
# Which network interface do you wish to configure? (or 'done') [vr0] vr0
# IPv4 address for vr0? (or 'autoconf' or 'none') [autoconf] dhcp
# IPv6 address for vr0? (or 'autoconf' or 'none') [none] none
# Available network interfaces are: vr0 vr1 vr2 vr3 vlan0.
# Which network interface do you wish to configure? (or 'done') [done] done
# Using DNS domainname 2226.local
# Using DNS nameservers at 1.1.1.1

# Password for root account? <provided>
# Public ssh key for root account? [none] none
# Start sshd(8) by default? [yes] yes
# Change the default console to com0? [yes] yes
# Available speeds are: 9600 19200 38400 57600 115200.
# Which speed should com0 use? (or 'done') [19200] 19200
# Setup a user? (enter a lower-case loginname, or 'no') [no] fa1c0n
# Full name for user fa1c0n? [fa1c0n] fa1c0n
# Password for user fa1c0n? <provided>
# Public ssh key for user fa1c0n [none] ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJZR86R1Q5ralftKKAuhrWNvKfBfg1SsXsqko1MdT9N1OpkyUr5ROl9tV/AoA6Em+uuRlpWxYlWF4tD09C6YSh8wHjbkXc6tA8VAWbiz+eXC4lAKCjYafwXHeFaluNwn
# WARNING: root is targeted by password guessing attacks, pubkeys are safer.
# Allow root ssh login? (yes, no, prohibit-password) [no] no
# What timezone are you in? ('?' for list) [Europe/Stockholm] Europe/Stockholm

# Available disks are: wd0.
# Which disk is the root disk? ('?' for details) [wd0] wd0
# Disk: wd0       geometry: 992/64/63 [4001760 Sectors]
# Offset: 0       Signature: 0xAA55
#             Starting         Ending         LBA Info:
#  #: id      C   H   S -      C   H   S [       start:        size ]
# -------------------------------------------------------------------------------
#  0: 00      0   0   0 -      0   0   0 [           0:           0 ] unused
#  1: 00      0   0   0 -      0   0   0 [           0:           0 ] unused
#  2: 00      0   0   0 -      0   0   0 [           0:           0 ] unused
# *3: A6      0   1   2 -   1935  63  63 [          64:     7805888 ] OpenBSD
# partition 3 extends beyond the end of wd0
# Use (W)hole disk, use the (O)penBSD area or (E)dit the MBR? [OpenBSD] OpenBSD
# URL to autopartitioning template for disklabel? [none] http://192.168.150.197/openbsd-pgdb.disklabel
# Fetching http://192.168.150.197/openbsd-pgdb.disklabel
# /dev/rwd0a: 1953.0MB in 3999744 sectors of 512 bytes
# 10 cylinder groups of 202.50MB, 12960 blocks, 25920 inodes each
# /dev/wd0a (9645c55566340b66.a) on /mnt type ffs (rw, asynchronous, local)

# Let's install the sets!
# Location of sets? (disk http or 'done') [http] http
# HTTP proxy URL? (e.g. 'http://proxy:8080', or 'none') [none] none
# HTTP Server? (hostname, list#, 'done' or '?') ftp.eu.openbsd.org
# Server directory? [pub/OpenBSD/7.2/i386] pub/OpenBSD/7.2/i386

# Select sets by entering a set name, a file name pattern or 'all'. De-select
# sets by prepending a '-', e.g.: '-game*'. Selected sets are labelled '[X]'.
#     [X] bsd           [X] comp72.tgz    [X] xbase72.tgz   [X] xserv72.tgz
#     [X] bsd.rd        [X] man72.tgz     [X] xshare72.tgz
#     [X] base72.tgz    [X] game72.tgz    [X] xfont72.tgz
# Set name(s)? (or 'abort' or 'done') [done] -all bsd* base* etc* man* site* comp*
#     [X] bsd           [X] comp72.tgz    [ ] xbase72.tgz   [ ] xserv72.tgz
#     [X] bsd.rd        [X] man72.tgz     [ ] xshare72.tgz
#     [X] base72.tgz    [ ] game72.tgz    [ ] xfont72.tgz
# Set name(s)? (or 'abort' or 'done') [done] done
# Cannot determine prefetch area. Continue without verification? [no] yes
# Installing bsd          100% |**************************| 14770 KB    00:08
# Installing bsd.rd       100% |**************************|  3968 KB    00:02
# Installing base72.tgz    80% |********************      |   182 MB    00:56 ETAfw_update: added none; updated none; kept none
# Relinking to create unique kernel... done.

# CONGRATULATIONS! Your OpenBSD install has been successfully completed!

# When you login to your new system the first time, please read your mail
# using the 'msyncing disks... done
# rebooting...


# POST: 012345689bcefghips1234ajklnopqr,,,tvwxy








# comBIOS ver. 1.33  20070103  Copyright (C) 2000-2007 Soekris Engineering.

# net5501

# 0512 Mbyte Memory                        CPU Geode LX 500 Mhz

# Pri Mas  SanDisk SDCFH2-002G             LBA Xlt 992-64-63  2001 Mbyte

# Slot   Vend Dev  ClassRev Cmd  Stat CL LT HT  Base1    Base2   Int
# -------------------------------------------------------------------
# 0:01:2 1022 2082 10100000 0006 0220 08 00 00 A0000000 00000000 10
# 0:06:0 1106 3053 02000096 0117 0210 08 40 00 0000E101 A0004000 11
# 0:07:0 1106 3053 02000096 0117 0210 08 40 00 0000E201 A0004100 05
# 0:08:0 1106 3053 02000096 0117 0210 08 40 00 0000E301 A0004200 09
# 0:09:0 1106 3053 02000096 0117 0210 08 40 00 0000E401 A0004300 12
# 0:20:0 1022 2090 06010003 0009 02A0 08 40 80 00006001 00006101
# 0:20:2 1022 209A 01018001 0005 02A0 08 00 00 00000000 00000000
# 0:21:0 1022 2094 0C031002 0006 0230 08 00 80 A0005000 00000000 15
# 0:21:1 1022 2095 0C032002 0006 0230 08 00 00 A0006000 00000000 15

#  1 Seconds to automatic boot.   Press Ctrl-P for entering Monitor.
# Using drive 0, partition 3.
# Loading......
# probing: pc0 com0 com1 mem[639K 511M a20=on]
# disk: hd0+
# >> OpenBSD/i386 BOOT 3.44
# switching console to com0
#                          >> OpenBSD/i386 BOOT 3.44
# boot>
# booting hd0a:/bsd: 10447383+2520068+217096+0+1134592 [710082+107+592032+636766]=0xf8386c
# entry point at 0x201000

# [ using 1939564 bytes of bsd ELF symbol table ]
# Copyright (c) 1982, 1986, 1989, 1991, 1993
#         The Regents of the University of California.  All rights reserved.
# Copyright (c) 1995-2022 OpenBSD. All rights reserved.  https://www.OpenBSD.org

# OpenBSD 7.2 (GENERIC) #381: Tue Sep 27 12:41:39 MDT 2022
#     deraadt@i386.openbsd.org:/usr/src/sys/arch/i386/compile/GENERIC
# real mem  = 536363008 (511MB)
# avail mem = 509685760 (486MB)
# random: good seed from bootblocks
# mpath0 at root
# scsibus0 at mpath0: 256 targets
# mainbus0 at root
# bios0 at mainbus0: date 20/70/03, BIOS32 rev. 0 @ 0xfac40
# pcibios0 at bios0: rev 2.0 @ 0xf0000/0x10000
# pcibios0: pcibios_get_intr_routing - function not supported
# pcibios0: PCI IRQ Routing information unavailable.
# pcibios0: PCI bus #0 is the last bus
# bios0: ROM list: 0xc8000/0xa800
# cpu0 at mainbus0: (uniprocessor)
# cpu0: Geode(TM) Integrated Processor by AMD PCS ("AuthenticAMD" 586-class) 500 MHz, 05-0a-02
# cpu0: FPU,DE,PSE,TSC,MSR,CX8,SEP,PGE,CMOV,CFLUSH,MMX,MMXX,3DNOW2,3DNOW
# mtrr: K6-family MTRR support (2 registers)
# amdmsr0 at mainbus0
# pci0 at mainbus0 bus 0: configuration mode 1 (no bios)
# 0:20:0: io address conflict 0x6100/0x100
# 0:20:0: io address conflict 0x6200/0x200
# pchb0 at pci0 dev 1 function 0 "AMD Geode LX" rev 0x31
# glxsb0 at pci0 dev 1 function 2 "AMD Geode LX Crypto" rev 0x00: RNG AES
# vr0 at pci0 dev 6 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 11, address 00:00:24:ca:68:10
# ukphy0 at vr0 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr1 at pci0 dev 7 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 5, address 00:00:24:ca:68:11
# ukphy1 at vr1 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr2 at pci0 dev 8 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 9, address 00:00:24:ca:68:12
# ukphy2 at vr2 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr3 at pci0 dev 9 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 12, address 00:00:24:ca:68:13
# ukphy3 at vr3 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# glxpcib0 at pci0 dev 20 function 0 "AMD CS5536 ISA" rev 0x03: rev 3, 32-bit 3579545Hz timer, watchdog, gpio, i2c
# gpio0 at glxpcib0: 32 pins
# iic0 at glxpcib0
# pciide0 at pci0 dev 20 function 2 "AMD CS5536 IDE" rev 0x01: DMA, channel 0 wired to compatibility, channel 1 wired to compatibility
# wd0 at pciide0 channel 0 drive 0: <SanDisk SDCFH2-002G>
# wd0: 4-sector PIO, LBA, 1953MB, 4001760 sectors
# wd0(pciide0:0:0): using PIO mode 4, DMA mode 2
# pciide0: channel 1 ignored (disabled)
# ohci0 at pci0 dev 21 function 0 "AMD CS5536 USB" rev 0x02: irq 15, version 1.0, legacy support
# ehci0 at pci0 dev 21 function 1 "AMD CS5536 USB" rev 0x02: irq 15
# usb0 at ehci0: USB revision 2.0
# uhub0 at usb0 configuration 1 interface 0 "AMD EHCI root hub" rev 2.00/1.00 addr 1
# isa0 at glxpcib0
# isadma0 at isa0
# com0 at isa0 port 0x3f8/8 irq 4: ns16550a, 16 byte fifo
# com0: console
# com1 at isa0 port 0x2f8/8 irq 3: ns16550a, 16 byte fifo
# pckbc0 at isa0 port 0x60/5 irq 1 irq 12
# pckbc0: unable to establish interrupt for irq 12
# pckbd0 at pckbc0 (kbd slot)
# wskbd0 at pckbd0: console keyboard
# pcppi0 at isa0 port 0x61
# spkr0 at pcppi0
# nsclpcsio0 at isa0 port 0x2e/2: NSC PC87366 rev 9: GPIO VLM TMS
# gpio1 at nsclpcsio0: 29 pins
# npx0 at isa0 port 0xf0/16: reported by CPUID; using exception 16
# usb1 at ohci0: USB revision 1.0
# uhub1 at usb1 configuration 1 interface 0 "AMD OHCI root hub" rev 1.00/1.00 addr 1
# vscsi0 at root
# scsibus1 at vscsi0: 256 targets
# softraid0 at root
# scsibus2 at softraid0: 256 targets
# root on wd0a (9645c55566340b66.a) swap on wd0b dump on wd0b
# Automatic boot in progress: starting file system checks.
# /dev/wd0a (9645c55566340b66.a): file system is clean; not checking
# pf enabled
# starting network
# reordering libraries:
# openssl: generating isakmpd RSA keys... done.
# openssl: generating iked ECDSA keys... done.
# ssh-keygen: generating new host keys: RSA ECDSA ED25519
# starting early daemons: syslogd pflogd ntpd.
# starting RPC daemons:.
# savecore: /dev/wd0b: Device not configured
# checking quotas: done.
# clearing /tmp
# kern.securelevel: 0 -> 1
# creating runtime link editor directory cache.
# preserving editor files.
# starting network daemons: sshd smtpd sndiod.
# running rc.firsttime
# fw_update: added none; updated none; kept none
# Checking for available binary patches...
# Run syspatch(8) to install:
# 001_x509        002_asn1        003_ukbd        004_expat
# starting local daemons: cron.
# Sun Nov 20 18:28:24 CET 2022

# OpenBSD/i386 (fwb.2226.local) (tty00)

login: root
Password: "f4U0+b*GlStu9I1AwR1@"
# OpenBSD 7.2 (GENERIC) #381: Tue Sep 27 12:41:39 MDT 2022

# Welcome to OpenBSD: The proactively secure Unix-like operating system.

# Please use the sendbug(1) utility to report bugs in the system.
# Before reporting a bug, please try to reproduce it with the latest
# version of the code.  With bug reports, please try to ensure that
# enough information to reproduce the problem is enclosed, and if a
# known fix for it exists, include that as well.

# You have mail.
# fwb#

ifconfig vr0 | grep inet
    # inet 192.168.150.200 netmask 0xffffff00 broadcast 192.168.150.255

##########################################################
# - ssh to FWB from FWA
##########################################################

# - import keys from mac terminal
ssh -A fa1c0n@10.0.0.4

# - ssh to new machine
ssh fa1c0n@192.168.150.200
# The authenticity of host '192.168.150.200 (192.168.150.200)' can't be established.
# ED25519 key fingerprint is SHA256:zWO6hqg0PRGarj2CGVN6cPdckOMZcgNqJ4gFnHINMa0.
# This key is not known by any other names.
# Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
# Warning: Permanently added '192.168.150.200' (ED25519) to the list of known hosts.
# OpenBSD 7.2 (GENERIC) #381: Tue Sep 27 12:41:39 MDT 2022

# Welcome to OpenBSD: The proactively secure Unix-like operating system.

# Please use the sendbug(1) utility to report bugs in the system.
# Before reporting a bug, please try to reproduce it with the latest
# version of the code.  With bug reports, please try to ensure that
# enough information to reproduce the problem is enclosed, and if a
# known fix for it exists, include that as well.

# fwb$
