#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Secure SSH
##########################################################

cd /etc/ssh/
mkdir -pm700 /local`pwd`/RCS
ln -s /local`pwd`/RCS

ci -t- -u /etc/ssh/sshd_config
co -l /etc/ssh/sshd_config

cat <<EOF | patch -p0
===================================================================
RCS file: /etc/ssh/RCS/sshd_config,v
retrieving revision 1.1
diff -u -r1.1 /etc/ssh/sshd_config
--- /etc/ssh/sshd_config        2013/07/30 01:51:02     1.1
+++ /etc/ssh/sshd_config        2013/07/30 01:51:13
@@ -1,4 +1,4 @@
-#      $OpenBSD: sshd_config,v 1.1 2013/07/30 00:51:02 root Exp root $
+#      $OpenBSD: sshd_config,v 1.1 2013/07/30 00:51:02 root Exp $
 
 # This is the sshd server system-wide configuration file.  See
 # sshd_config(5) for more information.
@@ -35,7 +35,7 @@
 # Authentication:
 
 #LoginGraceTime 2m
-#PermitRootLogin yes
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

ci -t- -m"Securing SSH" -u /etc/ssh/sshd_config
kill -HUP `cat /var/run/sshd.pid`

