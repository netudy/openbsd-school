#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Installation packages
##########################################################

export PKG_PATH=http://ftp.eu.openbsd.org/pub/OpenBSD/`uname -r`/packages/`machine -a`/

cat <<"EOF" | while read package; do pkg_add -v $package; done
bash-5.1.16.tgz
wget-1.21.3.tgz
emacs-28.2-no_x11.tgz
pftop-0.7p19.tgz
nmap-7.91p2.tgz
ifstat-1.1p5.tgz
minicom-2.8.tgz
picocom-3.1.tgz
conserver-8.2.7.tgz
screen-4.9.0.tgz
python-3.9.14.tgz
EOF

ln -sf /usr/local/bin/python3.9 /usr/bin/python3
