#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# - reset root password
# https://swordfish.wordpress.com/2006/06/23/openbsd-hack-single-user-mode-reset-root-password/
##########################################################

reset FWA (phisically, push reset button)

# - wait for OpenBSD pre-boot prompt
# >> OpenBSD/i386 BOOT 2.06
# boot>

# - boot single user
boot -s
Enter pathname of shell or RETURN for sh: "<ENTER>"

fsck /
fsck /home
fsck /usr

mount -a

# - reset the root password
passwd
