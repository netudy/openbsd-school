#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# Install src and ports
##########################################################
# - fix clock first
rdate ntp1.sp.se

pkg_add wget
pkg_add screen

# NWE soekris fix for small /usr filespace
mkdir /home/src
rm -rf /usr/src
ln -s /home/src /usr/src

cd /usr/src && wget http://ftp.eu.openbsd.org/pub/OpenBSD/7.2/sys.tar.gz
cd /usr/src && wget http://ftp.eu.openbsd.org/pub/OpenBSD/7.2/src.tar.gz

time tar xzf sys.tar.gz && time tar xzf src.tar.gz

##########################################################
# Update kernel and userland using latest patches
##########################################################


# cd /usr/src && wget ftp://mirror.yandex.ru/pub/OpenBSD/7.2/ports.tar.gz
# ln -s /usr/src/ports /usr/ports

# cd /usr/src && tar xzf ports.tar.gz
# cd /usr/ports/devel/grcs/
# make install
# cd /usr/bin/ && for file in rlog rcsmerge rcsdiff rcsclean rcs merge ident co ci; do mv $file o$file; \
#   ln -s /usr/local/bin/g$file /usr/bin/$file; done

cat <<"EOF" > /etc/do_patch_all.sh
cd /usr/src
rm -f 7.2.tar.gz
wget https://ftp.openbsd.org/pub/OpenBSD/patches/7.2.tar.gz

tar zxf 7.2.tar.gz

cd 7.2/common
# Apply by doing:
signify -Vep /etc/signify/openbsd-72-base.pub -x 001_x509.patch.sig \
        -m - | (cd /usr/src && patch -p0)

signify -Vep /etc/signify/openbsd-72-base.pub -x 002_asn1.patch.sig \
        -m - | (cd /usr/src && patch -p0)

signify -Vep /etc/signify/openbsd-72-base.pub -x 003_ukbd.patch.sig \
        -m - | (cd /usr/src && patch -p0)

signify -Vep /etc/signify/openbsd-72-base.pub -x 004_expat.patch.sig \
        -m - | (cd /usr/src && patch -p0)

# And then rebuild and install a new kernel:
    KK=`sysctl -n kern.osversion | cut -d# -f1`
    cd /usr/src/sys/arch/`machine`/compile/$KK
    make obj
    make config
    make
    make install

cd /usr/src/lib/libcrypto
    make obj
    make includes
    make
    make install

# And then rebuild and install libexpat:
    cd /usr/src/lib/libexpat
    make obj
    make
    make install
EOF

time sh /etc/do_patch_all.sh

