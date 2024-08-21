#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# OpenBSD 7.2 setup for Soekris Net5501 on OSX Ventura
##########################################################
# To do:
# - install minicom 'port install minicom' set baud 19200
# - install tftp 'sudo port install tftp-hpa'
# - plugin serial/ethernet adapter
# - run 'ioreg -c IOSerialBSDClient | grep usb'
# - setup sharing for your serial/ethernet adapter
# Good to know:
# - sudo systemsetup -listtimezones

sudo bash
# password xxxxxx

rm -rf /private/tftpboot/ /etc/bootpd.plist
/bin/launchctl unload -w /System/Library/LaunchDaemons/bootps.plist

cat <<"EOF" > /etc/bootpd.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Subnets</key>
    <array>
        <dict>
            <key>_creator</key>
            <string>com.apple.NetworkSharing</string>
            <key>allocate</key>
            <true/>
            <key>dhcp_domain_name_server</key>
            <array>
                <string>192.168.2.1</string>
            </array>
            <key>dhcp_router</key>
            <string>192.168.2.1</string>
            <key>interface</key>
            <string>bridge100</string>
            <key>lease_max</key>
            <integer>86400</integer>
            <key>lease_min</key>
            <integer>86400</integer>
            <key>name</key>
            <string>192.168.2/24</string>
            <key>net_address</key>
            <string>192.168.2.0</string>
            <key>net_mask</key>
            <string>255.255.255.0</string>
            <key>net_range</key>
            <array>
                <string>192.168.2.2</string>
                <string>192.168.2.254</string>
            </array>
            <key>dhcp_option_66</key>
            <string>192.168.2.1</string>
            <key>dhcp_option_67</key>
            <string>pxeboot</string>
        </dict>
    </array>
    <key>bootp_enabled</key>
    <false/>
    <key>detect_other_dhcp_server</key>
    <array>
        <string>bridge100</string>
    </array>
    <key>dhcp_enabled</key>
    <array>
        <string>bridge100</string>
    </array>
    <key>dhcp_ignore_client_identifier</key>
    <true/>
    <key>ignore_allow_deny</key>
    <array>
        <string>bridge100</string>
    </array>
    <key>use_server_config_for_dhcp_options</key>
    <false/>
</dict>
</plist>
EOF
exit

sudo mkdir /private/tftpboot
cd /private/tftpboot
sudo wget --no-check-certificate https://ftp.eu.openbsd.org/pub/OpenBSD/7.2/i386/pxeboot
sudo wget --no-check-certificate https://ftp.eu.openbsd.org/pub/OpenBSD/7.2/i386/bsd
sudo wget --no-check-certificate https://ftp.eu.openbsd.org/pub/OpenBSD/7.2/i386/bsd.rd

sudo cp pxeboot pxeboo
sudo chmod 644 /private/tftpboot/*
sudo /bin/launchctl load -w /System/Library/LaunchDaemons/bootps.plist
sudo pkill tftpd
sudo tftpd -L -s /private/tftpboot/

# - New terminal tab
minicom -c on

# - New terminal tab
sudo mkdir -p /private/tftpboot/etc
sudo bash
cat <<"EOF" > /private/tftpboot/etc/boot.conf
set tty com0
stty com0 19200
boot tftp:/bsd.rd
EOF
exit

##########################################################
# - Plug-in power to Soekris
# - hit 'ctrl+P'
##########################################################

# Welcome to minicom 2.8

# OPTIONS:
# Compiled on Oct 25 2021, 06:07:01.
# Port /dev/tty.usbserial-14310, 15:43:35

# Press Meta-Z for help on special keys



# POST: 012345689bcefghips1234ajklnopqr,,,tvwxy








# comBIOS ver. 1.33  20070103  Copyright (C) 2000-2007 Soekris Engineering.

# net5501

# 0512 Mbyte Memory                        CPU Geode LX 500 Mhz

# Pri Mas  SanDisk SDCFH2-002G             LBA Xlt 992-64-63  2001 Mbyte
# Pri Sla  ST9120823AS                     LBA Xlt 1024-255-63  117 Gbyte

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

#  9 Seconds to automatic boot.   Press Ctrl-P for entering Monitor.

# comBIOS Monitor.   Press ? for help.

boot f0

# Intel UNDI, PXE-2.0 (build 082)
# Copyright (C) 1997,1998,1999  Intel Corporation
# VIA Rhine III Management Adapter v2.43 (2005/12/15)

# CLIENT MAC ADDR: 00 00 24 CA 68 04
# CLIENT IP: 192.168.2.2  MASK: 255.255.255.0  DHCP IP: 192.168.2.1
# GATEWAY IP: 192.168.2.1
# probing: pc0 com0 com1 pxe![2.1] mem[639K 511M a20=on]
# disk: hd0+ hd1+
# net: mac 00:00:24:ca:68:04, ip 192.168.2.2, server 192.168.2.1
# >> OpenBSD/i386 PXEBOOT 3.44
# switching console to com0��fx��`����ff�����`f�x�`�����~�����~f��~��fxfx~�����x�ff~`�������fx��`��������~fx���f��~f��f�����~����f~��~
# com0: 19200 baud
# cannot open tftp:/etc/random.seed: No such file or directory
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
# vr0 at pci0 dev 6 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 11, address 00:00:24:ca:68:04
# ukphy0 at vr0 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr1 at pci0 dev 7 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 5, address 00:00:24:ca:68:05
# ukphy1 at vr1 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr2 at pci0 dev 8 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 9, address 00:00:24:ca:68:06
# ukphy2 at vr2 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr3 at pci0 dev 9 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 12, address 00:00:24:ca:68:07
# ukphy3 at vr3 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# pcib0 at pci0 dev 20 function 0 "AMD CS5536 ISA" rev 0x03
# pciide0 at pci0 dev 20 function 2 "AMD CS5536 IDE" rev 0x01: DMA, channel 0 wired to compatibility, channel 1 wired to compatibility
# wd0 at pciide0 channel 0 drive 0: <SanDisk SDCFH2-002G>
# wd0: 4-sector PIO, LBA, 1953MB, 4001760 sectors
# wd1 at pciide0 channel 0 drive 1: <ST9120823AS>
# wd1: 16-sector PIO, LBA48, 114473MB, 234441648 sectors
# wd0(pciide0:0:0): using PIO mode 4, DMA mode 2
# wd1(pciide0:0:1): using PIO mode 4, Ultra-DMA mode 2
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
# PXE boot MAC address 00:00:24:ca:68:04, interface vr0
# root on rd0a swap on rd0b dump on rd0b
# WARNING: CHECK AND RESET THE DATE!
# erase ^?, werase ^W, kill ^U, intr ^C, status ^T

# Welcome to the OpenBSD/i386 7.2 installation program.
# WARNING: /mnt was not properly unmounted
# WARNING: /mnt was not properly unmounted
# Starting non-interactive mode in 5 seconds...
(I)nstall, (U)pgrade, (A)utoinstall or (S)hell? i
# At any prompt except password prompts you can escape to a shell by
# typing '!'. Default answers are shown in []'s and are selected by
# pressing RETURN.  You can exit this program at any time by pressing
# Control-C, but this can leave your system in an inconsistent state.

Terminal type? [vt220]
System hostname? (short form, e.g. 'foo') console

# Available network interfaces are: vr0 vr1 vr2 vr3 vlan0.
Which network interface do you wish to configure? (or 'done') [vr0]
IPv4 address for vr0? (or 'dhcp' or 'none') [dhcp]
# vr0: bound to 192.168.2.2 from 192.168.2.1 (8a:e9:fe:a6:11:64)
IPv6 address for vr0? (or 'autoconf' or 'none') [none]
# Available network interfaces are: vr0 vr1 vr2 vr3 vlan0.
Which network interface do you wish to configure? (or 'done') done
DNS domain name? (e.g. 'example.com') [my.domain]
# Using DNS nameservers at 192.168.2.1

Password for root account? (will not echo) f4U0+b*GlStu9I1AwR1@
Password for root account? (again) f4U0+b*GlStu9I1AwR1@
Start sshd(8) by default? [yes]
Change the default console to com0? [yes]
# Available speeds are: 9600 19200 38400 57600 115200.
Which speed should com0 use? (or 'done') [19200]
Setup a user? (enter a lower-case loginname, or 'no') [no]
# Since no user was setup, root logins via sshd(8) might be useful.
# WARNING: root is targeted by password guessing attacks, pubkeys are safer.
Allow root ssh login? (yes, no, prohibit-password) [no]

# Available disks are: wd0 wd1.
Which disk is the root disk? ('?' for details) [wd0]
# Disk: wd0       geometry: 992/64/63 [4001760 Sectors]
# Offset: 0       Signature: 0xAA55
#             Starting         Ending         LBA Info:
#  #: id      C   H   S -      C   H   S [       start:        size ]
# -------------------------------------------------------------------------------
#  0: 00      0   0   0 -      0   0   0 [           0:           0 ] unused
#  1: 00      0   0   0 -      0   0   0 [           0:           0 ] unused
#  2: 00      0   0   0 -      0   0   0 [           0:           0 ] unused
# *3: A6      0   1   2 -    991  63  63 [          64:     3999680 ] OpenBSD
Use (W)hole disk, use the (O)penBSD area or (E)dit the MBR? [OpenBSD]
# The auto-allocated layout for wd0 is:
# #                size           offset  fstype [fsize bsize   cpg]
#   a:          1889.3M               64  4.2BSD   2048 16384     1 # /
#   b:            63.6M          3869440    swap
#   c:          1954.0M                0  unused
Use (A)uto layout, (E)dit auto layout, or create (C)ustom layout? [a] c
# Label editor (enter '?' for help at any prompt)
wd0>a
# No space left, you need to shrink a partition
wd0>z
wd0*> a
partition: [a]
offset: [64]
size: [3999680]
FS type: [4.2BSD]
mount point: [none] /
wd0*> w
wd0> q
# No label changes.
# /dev/rwd0a: 1953.0MB in 3999680 sectors of 512 bytes
# 10 cylinder groups of 202.50MB, 12960 blocks, 25920 inodes each
# Available disks are: wd1.
Which disk do you wish to initialize? (or 'done') [done]
# /dev/wd0a (45c8566679f1c764.a) on /mnt type ffs (rw, asynchronous, local)

# Let's install the sets!
Location of sets? (disk http or 'done') [http]
HTTP proxy URL? (e.g. 'http://proxy:8080', or 'none') [none]
# (Unable to get list from openbsd.org, but that is OK)
HTTP Server? (hostname or 'done') ftp.eu.openbsd.org
Server directory? [pub/OpenBSD/7.2/i386]
# Unable to connect using HTTPS; using HTTP instead.

# Select sets by entering a set name, a file name pattern or 'all'. De-select
# sets by prepending a '-', e.g.: '-game*'. Selected sets are labelled '[X]'.
    # [X] bsd           [X] comp72.tgz    [X] xbase72.tgz   [X] xserv72.tgz
    # [X] bsd.rd        [X] man72.tgz     [X] xshare72.tgz
    # [X] base72.tgz    [X] game72.tgz    [X] xfont72.tgz
Set name(s)? (or 'abort' or 'done') [done] -game72.tgz
   # [X] bsd           [X] comp72.tgz    [X] xbase72.tgz   [ ] xserv72.tgz
   #  [X] bsd.rd        [X] man72.tgz     [ ] xshare72.tgz
   #  [X] base72.tgz    [ ] game72.tgz    [ ] xfont72.tgz
Set name(s)? (or 'abort' or 'done') [done]
Cannot determine prefetch area. Continue without verification? [no] yes
# Installing bsd          100% |**************************| 14770 KB    00:04
# Installing bsd.rd       100% |**************************|  3968 KB    00:01
# Installing base72.tgz   100% |**************************|   227 MB    03:02
# Extracting etc.tgz      100% |**************************|   257 KB    00:00
# Installing comp72.tgz   100% |**************************| 39827 KB    01:10
# Installing man72.tgz    100% |**************************|  7610 KB    00:27
# Installing xbase72.tgz  100% |**************************| 47124 KB    00:43
# Extracting xetc.tgz     100% |**************************|  7237       00:00
Location of sets? (disk http or 'done') [done] Europe/Stockholm
# Saving configuration files... done.
# Making all device nodes... done.
# fw_update: added none; updated none; kept none
# Relinking to create unique kernel... done.

# CONGRATULATIONS! Your OpenBSD install has been successfully completed!

# When you login to your new system the first time, please read your mail
# using the 'mail' command.

# Exit to (S)hesyncing disks... done
# rebooting...

# POST: 012345689bcefghips1234ajklnopqr,,,tvwxy








# comBIOS ver. 1.33  20070103  Copyright (C) 2000-2007 Soekris Engineering.

# net5501

# 0512 Mbyte Memory                        CPU Geode LX 500 Mhz

# Pri Mas  SanDisk SDCFH2-002G             LBA Xlt 992-64-63  2001 Mbyte
# Pri Sla  ST9120823AS                     LBA Xlt 1024-255-63  117 Gbyte

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
# disk: hd0+ hd1+
# >> OpenBSD/i386 BOOT 3.44
# switching console to com0
#                          >> OpenBSD/i386 BOOT 3.44
# boot>
# booting hd0a:/bsd: 10439191+2520068+217096+0+1134592 [705973+107+592032+636766]=0xf80860
# entry point at 0x201000

# [ using 1935456 bytes of bsd ELF symbol table ]
# Copyright (c) 1982, 1986, 1989, 1991, 1993
#         The Regents of the University of California.  All rights reserved.
# Copyright (c) 1995-2022 OpenBSD. All rights reserved.  https://www.OpenBSD.org

# OpenBSD 7.2 (GENERIC) #381: Tue Sep 27 12:41:39 MDT 2022
#     deraadt@i386.openbsd.org:/usr/src/sys/arch/i386/compile/GENERIC
# real mem  = 536363008 (511MB)
# avail mem = 509698048 (486MB)
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
# vr0 at pci0 dev 6 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 11, address 00:00:24:ca:68:04
# ukphy0 at vr0 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr1 at pci0 dev 7 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 5, address 00:00:24:ca:68:05
# ukphy1 at vr1 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr2 at pci0 dev 8 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 9, address 00:00:24:ca:68:06
# ukphy2 at vr2 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# vr3 at pci0 dev 9 function 0 "VIA VT6105M RhineIII" rev 0x96: irq 12, address 00:00:24:ca:68:07
# ukphy3 at vr3 phy 1: Generic IEEE 802.3u media interface, rev. 3: OUI 0x004063, model 0x0034
# glxpcib0 at pci0 dev 20 function 0 "AMD CS5536 ISA" rev 0x03: rev 3, 32-bit 3579545Hz timer, watchdog, gpio, i2c
# gpio0 at glxpcib0: 32 pins
# iic0 at glxpcib0
# pciide0 at pci0 dev 20 function 2 "AMD CS5536 IDE" rev 0x01: DMA, channel 0 wired to compatibility, channel 1 wired to compatibility
# wd0 at pciide0 channel 0 drive 0: <SanDisk SDCFH2-002G>
# wd0: 4-sector PIO, LBA, 1953MB, 4001760 sectors
# wd1 at pciide0 channel 0 drive 1: <ST9120823AS>
# wd1: 16-sector PIO, LBA48, 114473MB, 234441648 sectors
# wd0(pciide0:0:0): using PIO mode 4, DMA mode 2
# wd1(pciide0:0:1): using PIO mode 4, Ultra-DMA mode 2
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
# root on wd0a (45c8566679f1c764.a) swap on wd0b dump on wd0b
# Automatic boot in progress: starting file system checks.
# /dev/wd0a (45c8566679f1c764.a): file system is clean; not checking
# pf enabled
# starting network
# reordering libraries: done.
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
# 001_x509        002_asn1
# starting local daemons: cron.
# Wed Oct 26 20:21:55 CEST 2022

# OpenBSD/i386 (console.my.domain) (tty00)

login: root
Password: f4U0+b*GlStu9I1AwR1@
# OpenBSD 7.2 (GENERIC) #381: Tue Sep 27 12:41:39 MDT 2022

# Welcome to OpenBSD: The proactively secure Unix-like operating system.

# Please use the sendbug(1) utility to report bugs in the system.
# Before reporting a bug, please try to reproduce it with the latest
# version of the code.  With bug reports, please try to ensure that
# enough information to reproduce the problem is enclosed, and if a
# known fix for it exists, include that as well.

# You have new mail.

ifconfig vr0 | grep inet
# inet 192.168.2.2 netmask 0xffffff00 broadcast 192.168.2.255
ssh -oPreferredAuthentications=password root@192.168.2.2
# The authenticity of host '192.168.2.2 (192.168.2.2)' can't be established.
# ED25519 key fingerprint is SHA256:GBEtLW99tDgX097Y+4zsDd16l9kfH45jkrp/afOWOGA.
# This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
# Warning: Permanently added '192.168.2.2' (ED25519) to the list of known hosts.
root@192.168.2.2 password: f4U0+b*GlStu9I1AwR1@
# Connection reset by 192.168.2.2 port 22
