#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Prepare doas
##########################################################

mkdir -p /local`pwd`/RCS
ln -s /local`pwd`/RCS RCS
mkdir /etc/doas

ci -t- -u /etc/doas
# /etc/doas,v  <--  /etc/doas

co -l /etc/doas
# /etc/doas,v  -->  /etc/doas
# no revisions present; generating empty revision 0.0
writable /etc/doas exists; remove it? [ny](n): "y"
# no revisions, so nothing can be locked
# co: /etc/doas: Is a directory
co -l /etc/doas
# /etc/doas,v  -->  /etc/doas
# no revisions present; generating empty revision 0.0
writable /etc/doas exists; remove it? [ny](n): "n"
# co: writable /etc/doas exists; checkout aborted

cat <<"EOF" > /etc/doas.conf
permit nopass keepenv :wheel
EOF

ci -t- -m"Enabled doas for wheel users. //$doas_USER" -u /etc/doas
# /etc/doas,v  <--  /etc/doas
chmod 440 /etc/doas

##########################################################
# Deploy sysadmins
##########################################################

useradd -m fa1c0n
usermod -G wheel fa1c0n
chsh -s /usr/local/bin/bash fa1c0n
cat <<"EOF" > /home/fa1c0n/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcMkYWwQRIjAah8w5/OScbjN7OwKaqomjTFhxB+1CzUnbpMvRey6ONjWmRuo6VgUOjoenKyPFeI6+205dhK0chPHqC3qZvkq8T9epT0KKRuxFRohWKD2TFpH9UFkyHVV6e6IxnnZpwnmLfIBe6VNSWNkewid7AzyvxhE2NgpufT03eqbHdRjrVoMtKtNZC9Upv/w17R253/VWVLdzzGjU4IHEHCPf4U5HDyjpXH1qTHm3ZFhYO9jGIca85rRgsIldVaJ8zJb++Fbhk7hDtzUIO+lqFsOEUwVzl4HKuQePB/vuw1yDqoQZsfwp5w56d3TPqzjzsTArfRuLdL3Q1VTcX fa1c0n@fa1c0ns-MBP.lan
EOF
chmod 750 /home/fa1c0n/
sha256 /home/fa1c0n/.ssh/authorized_keys
# SHA256 (/home/fa1c0n/.ssh/authorized_keys) = f86ff5865948de1d354f1a3ed0023cdc246a8e6231043fd95cce84b4e1e7b08b
