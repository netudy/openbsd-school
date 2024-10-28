#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Secure SSH Configuration
##########################################################

# Navigate to SSH configuration directory
cd /etc/ssh/

# Create the RCS directory for version control and create a symbolic link
mkdir -pm700 /local`pwd`/RCS
ln -s /local`pwd`/RCS

# Initialize version control for sshd_config
ci -t- -u /etc/ssh/sshd_config
# /etc/ssh/RCS/sshd_config,v  <--  /etc/ssh/sshd_config
# initial revision: 1.1
# done

# Check out sshd_config for editing
co -l /etc/ssh/sshd_config
# /etc/ssh/RCS/sshd_config,v  -->  /etc/ssh/sshd_config
# revision 1.1 (locked)
# done

# Apply the patch to secure SSH settings
cat <<EOF | patch -p0
===================================================================
RCS file: /etc/ssh/RCS/sshd_config,v
retrieving revision 1.1
diff -u -r1.1 /etc/ssh/sshd_config
--- /etc/ssh/sshd_config  2021/07/02 05:11:21 1.1
+++ /etc/ssh/sshd_config  $(date +"%Y/%m/%d %H:%M:%S")
@@ -1,4 +1,4 @@
-#  $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $
+#  $OpenBSD: sshd_config,v 1.105 $(date +"%Y/%m/%d %H:%M:%S") root Exp $

 # This is the sshd server system-wide configuration file.  See
 # sshd_config(5) for more information.
@@ -29,7 +29,7 @@
 # Authentication:

 #LoginGraceTime 2m
-PermitRootLogin yes
+PermitRootLogin no
 #StrictModes yes
 #MaxAuthTries 6
 #MaxSessions 10
@@ -57,7 +57,7 @@
 #IgnoreRhosts yes

 # To disable tunneled clear text passwords, change to no here!
-#PasswordAuthentication yes
+PasswordAuthentication no
 #PermitEmptyPasswords no

 # Change to no to disable s/key passwords
EOF
# Hmm...  Looks like a unified diff to me...
# The text leading up to this was:
# --------------------------
# |===================================================================
# |RCS file: /etc/ssh/RCS/sshd_config,v
# |retrieving revision 1.1
# |diff -u -r1.1 /etc/ssh/sshd_config
# |--- /etc/ssh/sshd_config  2021/07/02 05:11:21 1.1
# |+++ /etc/ssh/sshd_config  2024/10/25 07:49:32
# --------------------------
# Patching file /etc/ssh/sshd_config using Plan A...
# Hunk #1 succeeded at 1 with fuzz 1.
# Hunk #2 succeeded at 27 (offset -2 lines).
# Hunk #3 succeeded at 54 (offset -3 lines).
# done

# Check in the secured changes with a message
ci -t- -m"Securing SSH: Disabled root login and password authentication" -u /etc/ssh/sshd_config

# Reload SSH daemon to apply changes
kill -HUP $(cat /var/run/sshd.pid)

# SSH from host machine using new user
ssh fa1c0n@10.0.0.14
# OpenBSD 7.2 (GENERIC) #728: Tue Sep 27 11:49:18 MDT 2022

# Welcome to OpenBSD: The proactively secure Unix-like operating system.

# Please use the sendbug(1) utility to report bugs in the system.
# Before reporting a bug, please try to reproduce it with the latest
# version of the code.  With bug reports, please try to ensure that
# enough information to reproduce the problem is enclosed, and if a
# known fix for it exists, include that as well.
