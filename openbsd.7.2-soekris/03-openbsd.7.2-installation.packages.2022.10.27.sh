#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Installation packages
##########################################################

export PKG_PATH=http://ftp.eu.openbsd.org/pub/OpenBSD/`uname -r`/packages/`machine -a`/

cat <<"EOF" | while read package; do pkg_add -v $package; done
bash-5.2.26.tgz
wget-1.21.4p0.tgz
emacs-29.2-no_x11.tgz
pftop-0.7p19.tgz
nmap-7.91p5.tgz
ifstat-1.1p5.tgz
minicom-2.8.tgz
picocom-3.1.tgz
conserver-8.2.7p1.tgz
screen-4.9.1.tgz
python-3.9.18p0.tgz
EOF
# quirks-7.14:updatedb-0p0: ok
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# quirks-7.14: ok
# bash-5.2.26:libiconv-1.17: ok
# bash-5.2.26:gettext-runtime-0.22.5: ok
# Shell /usr/local/bin/bash appended to /etc/shells
# bash-5.2.26: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# wget-1.21.4p0:libunistring-0.9.7: ok
# wget-1.21.4p0:libidn2-2.3.0p0: ok
# wget-1.21.4p0:libpsl-0.21.1: ok
# wget-1.21.4p0:bzip2-1.0.8p0: ok
# wget-1.21.4p0:pcre2-10.37p2: ok
# wget-1.21.4p0: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# emacs-29.2-no_x11:xz-5.4.5: ok
# emacs-29.2-no_x11:libxml-2.12.5: ok
# emacs-29.2-no_x11:tree-sitter-0.20.8p1: ok
# emacs-29.2-no_x11:gmp-6.3.0: ok
# emacs-29.2-no_x11:jansson-2.14: ok
# emacs-29.2-no_x11:libunbound-1.19.1: ok
# emacs-29.2-no_x11:libnettle-3.9.1: ok
# emacs-29.2-no_x11:libtasn1-4.19.0: ok
# emacs-29.2-no_x11:lz4-1.9.4: ok
# emacs-29.2-no_x11:zstd-1.5.5: ok
# emacs-29.2-no_x11:libffi-3.4.4p1: ok
# emacs-29.2-no_x11:p11-kit-0.25.3: ok
# emacs-29.2-no_x11:brotli-1.0.9p0: ok
# emacs-29.2-no_x11:gnutls-3.8.3p0: ok
# emacs-29.2-no_x11:sqlite3-3.44.2: ok
# emacs-29.2-no_x11: ok
# Running tags: ok
# New and changed readme(s):
#     /usr/local/share/doc/pkg-readmes/emacs
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# pftop-0.7p19: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# nmap-7.91p5:lua-5.3.6: ok
# nmap-7.91p5:python-3.10.13p0: ok
# nmap-7.91p5:libssh2-1.11.0: ok
# nmap-7.91p5:pcre-8.45: ok
# nmap-7.91p5: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# ifstat-1.1p5: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# minicom-2.8:lrzsz-0.12.20p3: ok
# minicom-2.8:kermit-9.0.302p0: ok
# minicom-2.8: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# picocom-3.1: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# conserver-8.2.7p1: ok
# The following new rcscripts were installed: /etc/rc.d/conserver
# See rcctl(8) for details.
# New and changed readme(s):
#     /usr/local/share/doc/pkg-readmes/conserver
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# screen-4.9.1: ok
# Update candidates: quirks-7.14 -> quirks-7.14
# quirks-7.14 signed on 2024-03-17T12:22:05Z
# python-3.9.18p0: ok

ln -sf /usr/local/bin/python3.9 /usr/bin/python3
