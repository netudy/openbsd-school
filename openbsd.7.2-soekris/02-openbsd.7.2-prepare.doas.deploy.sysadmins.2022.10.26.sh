#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Prepare doas
##########################################################

# Create the RCS directory for version control, using pwd to ensure the correct path
mkdir -p `pwd`/RCS
ln -s `pwd`/RCS /etc/RCS

# Create an empty /etc/doas.conf file
touch /etc/doas.conf

# Initialize the /etc/doas.conf file under version control
ci -t- -u /etc/doas.conf
# /etc/RCS/doas.conf,v  <--  /etc/doas.conf
# initial revision: 1.1
# done

# Check out the /etc/doas.conf file for editing
co -l /etc/doas.conf
# /etc/RCS/doas.conf,v  -->  /etc/doas.conf
# revision 1.1 (locked)
# done

# Edit the doas.conf configuration file
cat <<"EOF" > /etc/doas.conf
permit nopass keepenv :wheel
EOF

# Check in the /etc/doas file with the appropriate message
ci -t- -m"Enabled doas for wheel users." -u /etc/doas.conf
# /etc/RCS/doas.conf,v  <--  /etc/doas.conf
# revision 1.2 (unlocked)
# done

# Set the correct permissions for /etc/doas.conf
chmod 440 /etc/doas.conf

##########################################################
# Deploy sysadmins
##########################################################

# Create the user 'fa1c0n'
useradd -m fa1c0n

# Add 'fa1c0n' to the 'wheel' group
usermod -G wheel fa1c0n

# Set the shell for 'fa1c0n' to bash
chsh -s /usr/local/bin/bash fa1c0n

# Create the authorized_keys file for SSH
cat <<"EOF" > /home/fa1c0n/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcMkYWwQRIjAah8w5/OScbjN7OwKaqomjTFhxB+1CzUnbpMvRey6ONjWmRuo6VgUOjoenKyPFeI6+205dhK0chPHqC3qZvkq8T9epT0KKRuxFRohWKD2TFpH9UFkyHVV6e6IxnnZpwnmLfIBe6VNSWNkewid7AzyvxhE2NgpufT03eqbHdRjrVoMtKtNZC9Upv/w17R253/VWVLdzzGjU4IHEHCPf4U5HDyjpXH1qTHm3ZFhYO9jGIca85rRgsIldVaJ8zJb++Fbhk7hDtzUIO+lqFsOEUwVzl4HKuQePB/vuw1yDqoQZsfwp5w56d3TPqzjzsTArfRuLdL3Q1VTcX fa1c0n@fa1c0ns-MBP.lan
EOF

# Create ssh config (only for linux/windows environments, OSX won't need)
cat <<"EOF" > /home/fa1c0n/.ssh/config
# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/fa1c0n.wsl

# OpenBSD
Host 10.49.90.129
  HostName 10.49.90.129
  IdentityFile ~/.ssh/fa1c0n.wsl
EOF

# Set the correct permissions for the user's home directory and SSH keys
chmod 750 /home/fa1c0n/
chmod 600 /home/fa1c0n/.ssh/authorized_keys

# Verify the SHA256 checksum of the authorized_keys file
sha256 /home/fa1c0n/.ssh/authorized_keys
# SHA256 (/home/fa1c0n/.ssh/authorized_keys) = f86ff5865948de1d354f1a3ed0023cdc246a8e6231043fd95cce84b4e1e7b08b
