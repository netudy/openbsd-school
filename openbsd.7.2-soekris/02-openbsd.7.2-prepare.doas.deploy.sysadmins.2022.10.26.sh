#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Prepare doas
##########################################################

mkdir -p /local`pwd`/RCS
ln -s /local`pwd`/RCS
mkdir /etc/doas

ci -t- -u /etc/doas
# /etc/doas,v  <--  /etc/doas
# initial revision: 1.1
# done
co -l /etc/doas
# /etc/doas,v  -->  /etc/doas
# revision 1.1 (locked)
# done

cat <<"EOF" > /etc/doas.conf
permit nopass keepenv :wheel
EOF

ci -t- -m"Enabled doas for wheel users. //$doas_USER" -u /etc/doas
# /etc/doas,v  <--  /etc/doas
# ci: /etc/doas,v: no lock set by root
chmod 440 /etc/doas

##########################################################
# Deploy sysadmins
##########################################################

useradd -m fa1c0n
usermod -G wheel fa1c0n
chsh -s /usr/local/bin/bash fa1c0n
cat <<"EOF" > /home/fa1c0n/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJZR86R1Q5ralftKKAuhrWNvKfBfg1SsXsqko1MdT9N1OpkyUr5ROl9tV/AoA6Em+uuRlpWxYlWF4tD09C6YSh8wHjbkXc6tA8VAWbiz+eXC4lAKCjYafwXHeFaluNwqZzev7PflueH3VHhqOFmwHGmYgqC7jMxC4YSSnbSNSjITH4CKHrckXH6ly33aXe1TdP0PZ7+EUKWmgGrhKr+765OjpNESkn6l+mT1/cpz5Vy9Fea7x0FfeoNn6T4N1zaLqRWCuOG91GiT3Nhd1irzATT3HA28XAOlxm87Clz6aNFYwYdwopDY0RIJCyZ1D4Zq/zWKbAwbIeGZrbD7xhdtLYA59+v/Ft7odcrRShhuRplV3wMgx8Cwb6XOLyyeKIjh0+MUBrBl+LfQSwu74ZMANukAA4NB0iApoYyQDhc4ea/qgnOPXtdeKjAB/2E0MKbtXvQ+w2TaBMErngXi4GHMKSd7KsWtivHEvLU/x1Oupjf+PXOkrGfeAwvqegwkBh5i8= fa1c0n@fa1c0n
EOF
chmod 750 /home/fa1c0n/
sha256 /home/fa1c0n/.ssh/authorized_keys
# SHA256 (/home/fa1c0n/.ssh/authorized_keys) = ce1202a982f461cd2eddf39d9c1280a1712643461a0fc6f6f2d3294feb9d3654

