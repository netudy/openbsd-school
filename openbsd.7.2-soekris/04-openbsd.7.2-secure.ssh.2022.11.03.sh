#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Secure SSH
##########################################################

# Change to the SSH configuration directory
cd /etc/ssh/

# Create the RCS directory for version control, ensuring correct permissions and path
mkdir -pm700 `pwd`/RCS
ln -s `pwd`/RCS /etc/ssh/RCS

# Initialize the sshd_config file under version control
ci -t- -u /etc/ssh/sshd_config
# /etc/ssh/sshd_config,v  <--  /etc/ssh/sshd_config
# initial revision: 1.1
# done

# Check out the sshd_config file for editing
co -l /etc/ssh/sshd_config
# /etc/ssh/sshd_config,v  -->  /etc/ssh/sshd_config
# revision 1.1 (locked)
# done

# Apply the patch to secure SSH
cat <<EOF | patch -p0
===================================================================
RCS file: /etc/ssh/RCS/sshd_config,v
retrieving revision 1.1
diff -u -r1.1 /etc/ssh/sshd_config
--- /etc/ssh/sshd_config        2021/07/02 05:11:21     1.1
+++ /etc/ssh/sshd_config        2024/08/20 01:51:13
@@ -1,4 +1,4 @@
-#      $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $
+#      $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

 # This is the sshd server system-wide configuration file.  See
 # sshd_config(5) for more information.
@@ -35,7 +35,7 @@
 # Authentication:

 #LoginGraceTime 2m
-PermitRootLogin yes
+PermitRootLogin no
 #StrictModes yes
 #MaxAuthTries 6
 #MaxSessions 10
@@ -63,7 +63,7 @@
 #IgnoreRhosts yes

 # To disable tunneled clear text passwords, change to no here!
-#PasswordAuthentication yes
+PasswordAuthentication no
 #PermitEmptyPasswords no

 # Change to no to disable s/key passwords
EOF

# Check in the sshd_config file with the appropriate message
ci -t- -m"Securing SSH" -u /etc/ssh/sshd_config
# /etc/ssh/sshd_config,v  <--  /etc/ssh/sshd_config
# new revision: 1.2; previous revision: 1.1
# done

# Reload SSH service to apply changes
kill -HUP `cat /var/run/sshd.pid`

ssh fa1c0n@10.49.90.129
# OpenBSD 7.2 (GENERIC) #728: Tue Sep 27 11:49:18 MDT 2022

# Welcome to OpenBSD: The proactively secure Unix-like operating system.

# Please use the sendbug(1) utility to report bugs in the system.
# Before reporting a bug, please try to reproduce it with the latest
# version of the code.  With bug reports, please try to ensure that
# enough information to reproduce the problem is enclosed, and if a
# known fix for it exists, include that as well.

# -bash-5.1$
