## CLIENT
brew install openvpn
mkdir ~/src
cd ~/src
git clone https://github.com/OpenVPN/easy-rsa.git

sudo bash
mkdir /etc/openvpn
mkdir -p /etc/certificate/repository
cp -r ~/src/easy-rsa /etc/openvpn/easy-rsa
cd easy-rsa/easyrsa3/

./easyrsa init-pki

# Notice
# ------
# 'init-pki' complete; you may now create a CA or requests.

# Your newly created PKI dir is:
# * /etc/openvpn/easy-rsa/easyrsa3/pki

# * Using Easy-RSA configuration:

# * IMPORTANT: Easy-RSA 'vars' template file has been created in your new PKI.
#              Edit this 'vars' file to customise the settings for your PKI.
#              To use a global vars file, use global option --vars=<YOUR_VARS>

# * Using x509-types directory: /etc/openvpn/easy-rsa/easyrsa3/x509-types

cd pki
touch vars

cd /etc/openvpn/easy-rsa/easyrsa3/
./easyrsa build-ca nopass

# * Using SSL: openssl LibreSSL 3.3.6

# * Using Easy-RSA configuration: /etc/openvpn/easy-rsa/easyrsa3/pki/vars

# .........................+++++
# ...........+++++
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:"OpenVPN fa1c0n CA"

# Notice
# ------
# CA creation complete and you may now import and sign cert requests.
# Your new CA certificate file for publishing is at:
# /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt

# bash-3.2# ./easyrsa build-server-full vpnserver nopass

# * Using SSL: openssl LibreSSL 3.3.6

# * Using Easy-RSA configuration: /etc/openvpn/easy-rsa/easyrsa3/pki/vars
# Generating a 2048 bit RSA private key
# .............+++++
# ...............................+++++
# writing new private key to '/etc/openvpn/easy-rsa/easyrsa3/pki/b01496d1/temp.ef43437b'
# -----

# Notice
# ------
# Keypair and certificate request completed. Your files are:
# req: /etc/openvpn/easy-rsa/easyrsa3/pki/reqs/vpnserver.req
# key: /etc/openvpn/easy-rsa/easyrsa3/pki/private/vpnserver.key

# You are about to sign the following certificate.
# Please check over the details shown below for accuracy. Note that this request
# has not been cryptographically verified. Please be sure it came from a trusted
# source or that you have verified the request checksum with the sender.

# Request subject, to be signed as a server certificate for 825 days:

# subject=
#     commonName                = vpnserver


# Type the word 'yes' to continue, or any other input to abort.
  Confirm request details: "yes"

# Using configuration from /etc/openvpn/easy-rsa/easyrsa3/pki/b01496d1/temp.26a46d2b
# Check that the request matches the signature
# Signature ok
# The Subject's Distinguished Name is as follows
# commonName            :ASN.1 12:'vpnserver'
# Certificate is to be certified until Apr  3 14:42:15 2025 GMT (825 days)

# Write out database with 1 new entries
# Data Base Updated

# Notice
# ------
# Certificate created at: /etc/openvpn/easy-rsa/easyrsa3/pki/issued/vpnserver.crt

./easyrsa build-client-full client1 nopass

# * Using SSL: openssl LibreSSL 3.3.6

# * Using Easy-RSA configuration: /etc/openvpn/easy-rsa/easyrsa3/pki/vars
# Generating a 2048 bit RSA private key
# ...........+++++
# ............................................................................+++++
# writing new private key to '/etc/openvpn/easy-rsa/easyrsa3/pki/51f0ab38/temp.51a6cb74'
# -----

# Notice
# ------
# Keypair and certificate request completed. Your files are:
# req: /etc/openvpn/easy-rsa/easyrsa3/pki/reqs/client1.req
# key: /etc/openvpn/easy-rsa/easyrsa3/pki/private/client1.key

# You are about to sign the following certificate.
# Please check over the details shown below for accuracy. Note that this request
# has not been cryptographically verified. Please be sure it came from a trusted
# source or that you have verified the request checksum with the sender.

# Request subject, to be signed as a client certificate for 825 days:

# subject=
#     commonName                = client1


# Type the word 'yes' to continue, or any other input to abort.
   Confirm request details: "yes"

# Using configuration from /etc/openvpn/easy-rsa/easyrsa3/pki/51f0ab38/temp.0de865c9
# Check that the request matches the signature
# Signature ok
# The Subject's Distinguished Name is as follows
# commonName            :ASN.1 12:'client1'
# Certificate is to be certified until Apr  3 14:43:58 2025 GMT (825 days)

# Write out database with 1 new entries
# Data Base Updated

# Notice
# ------
# Certificate created at: /etc/openvpn/easy-rsa/easyrsa3/pki/issued/client1.crt

./easyrsa gen-dh

# * Using SSL: openssl LibreSSL 3.3.6

# * Using Easy-RSA configuration: /etc/openvpn/easy-rsa/easyrsa3/pki/vars
# Generating DH parameters, 2048 bit long safe prime, generator 2
# This is going to take a long time
# [ ... ]

# DH parameters appear to be ok.

# Notice
# ------

# DH parameters of size 2048 created
# at: /etc/openvpn/easy-rsa/easyrsa3/pki/dh.pem

## SERVER
export PKG_PATH=http://ftp.eu.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/
cat <<"EOF" | while read package; do pkg_add -v $package; done
openvpn-2.5.7.tgz
EOF
# Update candidates: quirks-6.42 -> quirks-6.42
# quirks-6.42 signed on 2022-09-29T09:49:28Z
# openvpn-2.5.7: ok
# The following new rcscripts were installed: /etc/rc.d/openvpn
# See rcctl(8) for details.
# New and changed readme(s):
# 	/usr/local/share/doc/pkg-readmes/openvpn

mkdir -p /etc/openvpn/keys/issued
mkdir -p /etc/openvpn/keys/private

cat <<"EOF" > /etc/openvpn/keys/ca.crt
-----BEGIN CERTIFICATE-----
MIIDRzCCAi+gAwIBAgIJAI48fN0tZvScMA0GCSqGSIb3DQEBCwUAMBwxGjAYBgNV
BAMMEU9wZW5WUE4gZmExYzBuIENBMB4XDTIyMTIzMDE0NDIwNFoXDTMyMTIyNzE0
NDIwNFowHDEaMBgGA1UEAwwRT3BlblZQTiBmYTFjMG4gQ0EwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC1WRVTbOZ9LvJHZxQtmxMf7kS/llRbz/G+Zc+j
0El2UrjVqVLmgotOmXU2LGesN6jhbisUPkoFYXIZaPTuw91W5qmmGlz0etyeVvBz
lrSXoB9Hi3J2tkC/sSHVFMigllN/JwNGFhOegOGUCkCI7TUolbDXXNsNoISp4zB3
ooa4eoaxW59Ikk15Vv6UDAFHaun7/TWKwb0NaqbEMkhY7B2ZAUTowoCVS63zhrmy
BMD43rH+n2LwfLQRKM33NVtrxTiMznb0te8JqUhfvnFTobZaRkmluaobr8pu27dE
DgJNmkRd/v2AYm3TMdyjXTdZpDmT7qaqDp7+l+dzSEIwFIWZAgMBAAGjgYswgYgw
DAYDVR0TBAUwAwEB/zAdBgNVHQ4EFgQUTHbtttUY2Ukpq3sRVzHYIDugFDswTAYD
VR0jBEUwQ4AUTHbtttUY2Ukpq3sRVzHYIDugFDuhIKQeMBwxGjAYBgNVBAMMEU9w
ZW5WUE4gZmExYzBuIENBggkAjjx83S1m9JwwCwYDVR0PBAQDAgEGMA0GCSqGSIb3
DQEBCwUAA4IBAQAWwbGCkBzd6Gi6xKY4DXEn34egKdzp8xLVDIX+vMVW+kk4AIyr
A7zKdNLaLqq+y2lLSaIgWsPAHmdoi8VX9z+O/uDpUyJbIbeH2tkevm3OPA9RT4uH
hu+PckIpo06JdDqYvTjdH5V/qjw5iZlVbkvvqjkWm9vJGIhptbW8/AkAuzAZc1Kt
e0XmTvd6DdkcaIIRqtm0Io5AGVB2g/Bgi3LNAGJbfNIbh0/gQWS5hl5aDiornu5J
C5jsu92hO9pNBKJcPggkYVanuflrmVMJImR3FK/ii3bKR3phOTU+X7nphR18+abp
0hrxIID7mDaUZrlLC0ywIR9DuttZKMYKFLv0
-----END CERTIFICATE-----
EOF

cat <<"EOF" > /etc/openvpn/keys/issued/vpnserver.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            21:de:94:25:76:a7:2e:f7:0e:6b:47:98:8d:1d:ca:c5
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=OpenVPN fa1c0n CA
        Validity
            Not Before: Dec 30 14:42:15 2022 GMT
            Not After : Apr  3 14:42:15 2025 GMT
        Subject: CN=vpnserver
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:a7:39:b4:dd:35:fd:b3:96:fa:b3:10:5a:03:4a:
                    74:e9:f1:7b:e0:f5:20:7e:7b:cc:82:06:a8:a0:6d:
                    35:22:ab:33:3a:a7:9a:32:d7:78:4f:fb:aa:42:01:
                    75:c4:7a:89:6f:3e:57:2b:97:b9:4e:30:e3:fa:74:
                    63:21:63:db:b9:83:42:71:ae:0b:50:c6:b0:ce:f5:
                    65:78:60:3b:4b:f0:a2:af:0c:45:83:7d:23:24:68:
                    dd:91:9c:7a:6d:87:52:71:ba:80:70:5b:f5:3b:1e:
                    3d:dd:a2:f7:e5:84:f1:5f:1b:1c:90:aa:20:61:79:
                    84:1c:8b:5b:6e:81:ec:14:62:3e:19:96:8b:17:71:
                    79:bf:2a:25:18:50:df:49:46:30:b0:5b:b8:b8:4c:
                    b6:66:90:30:c1:4c:d8:91:d9:b4:4f:e0:b3:ca:33:
                    14:fb:cf:11:23:4e:1c:17:84:7d:58:d5:9c:03:59:
                    46:e6:8c:30:47:ca:9f:03:a5:97:17:0a:0a:80:0b:
                    8a:95:3c:0f:a3:a1:3c:fa:cc:79:f2:b1:4d:b3:1b:
                    bb:6c:d1:7b:43:f9:24:99:2d:a3:fa:e3:f0:e3:46:
                    37:60:11:38:cd:9f:a5:2e:11:fe:5e:eb:70:87:9b:
                    63:aa:3b:25:c7:bf:79:cf:4f:3b:da:ae:56:65:a3:
                    60:37
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Subject Key Identifier:
                C6:7C:FE:44:E0:70:0C:0A:05:42:08:07:41:46:93:0E:02:3F:AF:2B
            X509v3 Authority Key Identifier:
                keyid:4C:76:ED:B6:D5:18:D9:49:29:AB:7B:11:57:31:D8:20:3B:A0:14:3B
                DirName:/CN=OpenVPN fa1c0n CA
                serial:8E:3C:7C:DD:2D:66:F4:9C

            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Key Usage:
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name:
                DNS:vpnserver
    Signature Algorithm: sha256WithRSAEncryption
         8d:8f:25:05:7f:6a:f7:2c:c1:99:0f:46:b3:8b:0b:48:48:40:
         00:2c:f2:bc:29:ae:f7:f4:d7:dd:f3:bf:10:66:67:e0:ff:b6:
         1f:a6:dc:e8:85:09:50:59:f3:10:66:9f:06:8c:9a:ce:07:11:
         89:a0:b7:42:19:90:36:0c:d5:84:0d:ff:4e:11:52:ee:4a:4c:
         6d:7c:08:5a:97:3c:86:81:34:a1:50:d0:f7:6c:aa:4c:20:3d:
         cf:16:cf:fc:14:52:d6:0a:53:b4:5b:45:a2:8e:ac:d5:ef:3b:
         a9:3b:92:80:8e:0e:02:97:4e:03:07:14:fc:07:ce:eb:40:71:
         7c:14:e1:18:07:1a:9c:e2:89:bc:41:0b:8b:55:60:61:87:95:
         89:d5:1a:8c:1e:4b:05:60:84:8a:f3:d8:6a:0d:23:5e:e3:89:
         b8:3c:6a:fe:6d:0f:f4:8a:1f:f1:8a:90:b6:4e:e5:1e:3d:1c:
         c8:c7:f4:63:f8:1c:51:8e:f8:7e:10:5d:14:65:d6:a8:67:87:
         6a:22:33:c6:01:f0:ac:cc:0b:c1:e5:0c:c4:0e:6b:f9:e6:95:
         2c:31:eb:5b:48:75:c9:4d:d4:24:da:55:db:2d:63:70:c4:14:
         0d:ac:36:26:6b:27:c7:aa:a2:aa:c0:17:19:9a:3c:b2:dd:d2:
         01:ad:2d:5b
-----BEGIN CERTIFICATE-----
MIIDbjCCAlagAwIBAgIQId6UJXanLvcOa0eYjR3KxTANBgkqhkiG9w0BAQsFADAc
MRowGAYDVQQDDBFPcGVuVlBOIGZhMWMwbiBDQTAeFw0yMjEyMzAxNDQyMTVaFw0y
NTA0MDMxNDQyMTVaMBQxEjAQBgNVBAMMCXZwbnNlcnZlcjCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAKc5tN01/bOW+rMQWgNKdOnxe+D1IH57zIIGqKBt
NSKrMzqnmjLXeE/7qkIBdcR6iW8+VyuXuU4w4/p0YyFj27mDQnGuC1DGsM71ZXhg
O0vwoq8MRYN9IyRo3ZGcem2HUnG6gHBb9TsePd2i9+WE8V8bHJCqIGF5hByLW26B
7BRiPhmWixdxeb8qJRhQ30lGMLBbuLhMtmaQMMFM2JHZtE/gs8ozFPvPESNOHBeE
fVjVnANZRuaMMEfKnwOllxcKCoALipU8D6OhPPrMefKxTbMbu2zRe0P5JJkto/rj
8ONGN2AROM2fpS4R/l7rcIebY6o7Jce/ec9PO9quVmWjYDcCAwEAAaOBszCBsDAJ
BgNVHRMEAjAAMB0GA1UdDgQWBBTGfP5E4HAMCgVCCAdBRpMOAj+vKzBMBgNVHSME
RTBDgBRMdu221RjZSSmrexFXMdggO6AUO6EgpB4wHDEaMBgGA1UEAwwRT3BlblZQ
TiBmYTFjMG4gQ0GCCQCOPHzdLWb0nDATBgNVHSUEDDAKBggrBgEFBQcDATALBgNV
HQ8EBAMCBaAwFAYDVR0RBA0wC4IJdnBuc2VydmVyMA0GCSqGSIb3DQEBCwUAA4IB
AQCNjyUFf2r3LMGZD0aziwtISEAALPK8Ka739Nfd878QZmfg/7YfptzohQlQWfMQ
Zp8GjJrOBxGJoLdCGZA2DNWEDf9OEVLuSkxtfAhalzyGgTShUND3bKpMID3PFs/8
FFLWClO0W0WijqzV7zupO5KAjg4Cl04DBxT8B87rQHF8FOEYBxqc4om8QQuLVWBh
h5WJ1RqMHksFYISK89hqDSNe44m4PGr+bQ/0ih/xipC2TuUePRzIx/Rj+BxRjvh+
EF0UZdaoZ4dqIjPGAfCszAvB5QzEDmv55pUsMetbSHXJTdQk2lXbLWNwxBQNrDYm
ayfHqqKqwBcZmjyy3dIBrS1b
-----END CERTIFICATE-----
EOF

cat <<"EOF" > /etc/openvpn/keys/private/vpnserver.key
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCnObTdNf2zlvqz
EFoDSnTp8Xvg9SB+e8yCBqigbTUiqzM6p5oy13hP+6pCAXXEeolvPlcrl7lOMOP6
dGMhY9u5g0JxrgtQxrDO9WV4YDtL8KKvDEWDfSMkaN2RnHpth1JxuoBwW/U7Hj3d
ovflhPFfGxyQqiBheYQci1tugewUYj4ZlosXcXm/KiUYUN9JRjCwW7i4TLZmkDDB
TNiR2bRP4LPKMxT7zxEjThwXhH1Y1ZwDWUbmjDBHyp8DpZcXCgqAC4qVPA+joTz6
zHnysU2zG7ts0XtD+SSZLaP64/DjRjdgETjNn6UuEf5e63CHm2OqOyXHv3nPTzva
rlZlo2A3AgMBAAECggEAYeCl2wBaAT6yeBJvDRQMgE2Gm3H+VenyFnz9QAELo8Ie
1wr4dx+k3PPJgJ7IJnsua/1KGkrQ/FIjbhmnWAjRt7B7OHyNRPc2z7vUa3Ov4U/0
eI6vNToOUqZKYYr8IZWeDNEDkkBQtgyKW2qivCVm/aqpuobJMyRjzi1HE9RZsMep
iJbOrLe3p2d130yHMmGvtUh+Nt0+yfp49qcLUWeAwZerB6vrCzurM1W7IQnDfOyE
4SgH4pSnpY7z1Z9oJsArLJ/DQBfbtfsjBxamBLnFZH2ka4NAWx4NfS4ZsXFe2Bdx
ajgjtWusDm560rN9+xbv99dahDBILY7BXEMOE+YgCQKBgQDV0wr5XNSd2NWF548y
1wR+yAQoZBywADRdOQj3VeXTEAoJbbqHtnUuehXRPm8g+bDNuRoaawm6OjBthPU6
ExEwGgtviM9RbzRxRSNbBKsb17IR2d86orGdO27tfKBasqZ2sNlWAPPYlNVbgrxn
GW0mEsU0NhroazcGmMxm5IFz3QKBgQDINavsCrjpwqiK/ZDdZ+ZRGQapJynCuCvE
yf7K/MlR7dW2sS6Dwn5JvNrKGUXPHcK1hOIgoeTHJtGOdrEt1mGa/7EMewkVpVi4
jegxsalBNjPpipDzDtxADGoJYMrITpnNjcP7j+x3D1Usi7/ETljhCnzxKjUDVyQk
LdM1/kqdIwKBgQCuDKWoKToganoUD1LuzTspf+JyhlsboG7/WwfDXLZAwZOJ7Tmi
cpCcDmBn/Gw06UpTitKGoo4+elMlMs7yQMcC4pBgb3piDSUg9mg7FGe7uC2IflJI
xlnRZKl8wq88ZKM/heDDMu9KYovxe0+klHvWO/0t7MSmX29g/UuUjXgaOQKBgEpf
Las0XHZxmhxvjxXAF91+V2wUoT21HoUuqBiNiNeHawE/llDZugH4RqoWc0k5++9k
GoAWw557PBMY4j5tybpDS2igd8Jztp5wEJYNMhuIYAZcM/YmSgj805MCQrHgCOBD
zk6vqx6bMn+mtijdFcUbGUiY7jJ8d299Gl2PRfZTAoGBAL9vPilZOld18Gwn0ZrW
I0DFvWpcO0LJIYeM6ZbQIV4xBIht2sF8ajHaMHgsjRENSpcOQgFUs9UzUiyyzwsH
P1gOljgQIS+gPgJu1BTbPwaD0I44knqVDI51jLrT8VWjZ04WVlgjTrcMC4WQks7n
seJl3x4eNdppLvnSFZiBzlF5
-----END PRIVATE KEY-----
EOF

cat <<"EOF" > /etc/openvpn/dh.pem
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA356IzNt9qoWBA2+PTZveOv70HvCRHwsWO/3j8M7XK57JD1+EjDBA
DDG4fRerFtpsyjEWlF7pgd2L5rGNixKOmnwABAvOv2bOg/lwBj9cvvgWnUgZqI5k
oLDrldUPSTyR8QiVAY/CxhRqvqmTS0yL7258ZPPZm/jlCQH6OpvAQbYVhvG8y29Z
9hopl5dZbFV3NxHhQgbJbJwVyGlL6mrkOv4Ifqd0oCuEI39vbUo+w90l7JTjsDe/
LmlGlxbYzXdDs6rfCd4Hbem5vDZyFHCP23qBqNKw/P/qvJpYXLSfn5VXJQsvnSo7
yzj3BULR/Unyp87FA6IGsQVWXy+cFrOn4wIBAg==
-----END DH PARAMETERS-----
EOF

cat <<"EOF" > /etc/openvpn/server.conf
port 10443
proto udp
dev tun0
ca /etc/openvpn/keys/ca.crt
cert /etc/openvpn/keys/issued/vpnserver.crt
key /etc/openvpn/keys/private/vpnserver.key
dh /etc/openvpn/dh.pem
push "redirect-gateway def1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
keepalive 10 120
data-ciphers AES-256-GCM:AES-128-GCM
user _openvpn
group _openvpn
persist-key
persist-tun
status /var/log/openvpn-status.log
ifconfig-pool-persist /var/log/openvpn/ipp.txt
log-append /var/log/openvpn.log
verb 4
EOF

cat <<"EOF" > /etc/sysctl.conf
net.inet.ip.forwarding=1
net.inet.carp.preempt=1
EOF

sysctl net.inet.ip.forwarding=1

cat <<"EOF" > /etc/pf.conf
#   $OpenBSD: pf.conf,v 1.55 2017/12/03 20:40:04 sthen Exp $
#
# See pf.conf(5) and /etc/examples/pf.conf

set skip on lo

block return    # block stateless traffic
pass        # establish keep-state

# By default, do not permit remote connections to X11
block return in on ! lo0 proto tcp to port 6000:6010

# Port build user does not need network
block return out log proto {tcp udp} user _pbuild

match out on egress inet from !(egress) to any nat-to (egress:0)

# Internal services and traffic
pass quick on vr1 no state

# vpn 
tun_if = "tun0"
pass in on vr0 proto tcp from any to vr0 port {10443}
pass in quick on $tun_if  
EOF

pfctl -f /etc/pf.conf

cat <<"EOF" > /etc/hostname.tun0
up
!/usr/local/sbin/openvpn --daemon --config /etc/openvpn/server.conf
EOF

chmod 640 /etc/hostname.tun0
sh /etc/netstart tun0

rcctl stop openvpn

openvpn --config /etc/openvpn/server.conf
# netstat -nr -f inet | more
# netstat -nr -f inet | grep tun0

## CLIENT
cd /etc/openvpn
mkdir server
mkdir -p fa1c0n
cp -r keys/ server/

cp easy-rsa/easyrsa3/pki/ca.crt fa1c0n/
cp easy-rsa/easyrsa3/pki/issued/client1.crt fa1c0n/
cp easy-rsa/easyrsa3/pki/private/client1.key fa1c0n/

cat <<"EOF" > /etc/openvpn/fa1c0n/client.conf
client
proto udp
dev tun
remote fa1c0n.ddns.net 10443
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert client1.crt
key client1.key
comp-lzo
# route-nopull # This tells the OpenVPN client to not automatically add routes to the client's routing table and instead relies on the server to push the routes.
verb 9
--float
EOF

# - if port 10443 in use:
fstat | grep 10443
ps -fA | grep openvpn
kill -9 # enter pid here

# - very that client connected successfully
cat /var/log/openvpn.log
# 2023-01-17 14:36:27 WARNING: --topology net30 support for server configs with IPv4 pools will be removed in a future release. Please migrate to --topology subnet as soon as possible.
# 2023-01-17 14:36:27 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
# 2023-01-17 14:36:27 WARNING: file '/etc/openvpn/keys/private/vpnserver.key' is group or others accessible
# 2023-01-17 14:36:27 OpenVPN 2.5.7 i386-unknown-openbsd7.2 [SSL (OpenSSL)] [LZO] [LZ4] [MH/RECVDA] [AEAD] built on Sep 27 2022
# 2023-01-17 14:36:27 library versions: LibreSSL 3.6.0, LZO 2.10
# 2023-01-17 14:36:27 Diffie-Hellman initialized with 2048 bit key
# 2023-01-17 14:36:27 ROUTE_GATEWAY 10.0.0.1/255.255.255.192 IFACE=vr0
# 2023-01-17 14:36:27 TUN/TAP device /dev/tun0 opened
# 2023-01-17 14:36:27 Can't get interface info: Inappropriate ioctl for device (errno=25)
# 2023-01-17 14:36:27 Can't set interface info: Inappropriate ioctl for device (errno=25)
# 2023-01-17 14:36:27 /sbin/ifconfig tun0 10.8.0.1 10.8.0.2 mtu 1500 netmask 255.255.255.255 up
# 2023-01-17 14:36:27 /sbin/route add -net 10.8.0.0 -netmask 255.255.255.0 10.8.0.2
# add net 10.8.0.0: gateway 10.8.0.2
# 2023-01-17 14:36:27 Could not determine IPv4/IPv6 protocol. Using AF_INET
# 2023-01-17 14:36:27 Socket Buffers: R=[41600->41600] S=[9216->9216]
# 2023-01-17 14:36:27 UDPv4 link local (bound): [AF_INET][undef]:10443
# 2023-01-17 14:36:27 UDPv4 link remote: [AF_UNSPEC]
# 2023-01-17 14:36:27 MULTI: multi_init called, r=256 v=256
# 2023-01-17 14:36:27 IFCONFIG POOL IPv4: base=10.8.0.4 size=62
# 2023-01-17 14:36:27 Initialization Sequence Completed
# 2023-01-17 14:36:54 /sbin/route delete -net 10.8.0.0 10.8.0.2 -netmask 255.255.255.0
# delete net 10.8.0.0: gateway 10.8.0.2
# 2023-01-17 14:36:54 Closing TUN/TAP interface
# 2023-01-17 14:36:54 SIGINT[hard,] received, process exiting
# 2023-01-17 14:43:35 us=721407 WARNING: --topology net30 support for server configs with IPv4 pools will be removed in a future release. Please migrate to --topology subnet as soon as possible.
# 2023-01-17 14:43:35 us=724699 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
# 2023-01-17 14:43:35 us=725784 WARNING: file '/etc/openvpn/keys/private/vpnserver.key' is group or others accessible
# Options error: --crl-verify fails with '/etc/openvpn/keys/crl.pem': No such file or directory (errno=2)
# Options error: Please correct these errors.
# Use --help for more information.
# 2023-01-17 14:43:45 us=584967 WARNING: --topology net30 support for server configs with IPv4 pools will be removed in a future release. Please migrate to --topology subnet as soon as possible.
# 2023-01-17 14:43:45 us=585162 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
# 2023-01-17 14:43:45 us=586268 WARNING: file '/etc/openvpn/keys/private/vpnserver.key' is group or others accessible
# Options error: --crl-verify fails with '/etc/openvpn/keys/crl.pem': No such file or directory (errno=2)
# Options error: Please correct these errors.
# Use --help for more information.
# 2023-01-17 14:44:04 us=954725 WARNING: --topology net30 support for server configs with IPv4 pools will be removed in a future release. Please migrate to --topology subnet as soon as possible.
# 2023-01-17 14:44:04 us=954926 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
# 2023-01-17 14:44:04 us=955984 WARNING: file '/etc/openvpn/keys/private/vpnserver.key' is group or others accessible
# Options error: --crl-verify fails with '/etc/openvpn/keys/crl.pem': No such file or directory (errno=2)
# Options error: Please correct these errors.
# Use --help for more information.
# 2023-01-17 14:47:38 us=447602 WARNING: --topology net30 support for server configs with IPv4 pools will be removed in a future release. Please migrate to --topology subnet as soon as possible.
# 2023-01-17 14:47:38 us=447802 --cipher is not set. Previous OpenVPN version defaulted to BF-CBC as fallback when cipher negotiation failed in this case. If you need this fallback please add '--data-ciphers-fallback BF-CBC' to your configuration and/or add BF-CBC to --data-ciphers.
# 2023-01-17 14:47:38 us=449024 WARNING: file '/etc/openvpn/keys/private/vpnserver.key' is group or others accessible
# 2023-01-17 14:47:38 us=449375 Current Parameter Settings:
# 2023-01-17 14:47:38 us=449496   config = '/etc/openvpn/server.conf'
# 2023-01-17 14:47:38 us=449612   mode = 1
# 2023-01-17 14:47:38 us=449726   show_ciphers = DISABLED
# 2023-01-17 14:47:38 us=449837   show_digests = DISABLED
# 2023-01-17 14:47:38 us=449991   show_engines = DISABLED
# 2023-01-17 14:47:38 us=450105   genkey = DISABLED
# 2023-01-17 14:47:38 us=450216   genkey_filename = '[UNDEF]'
# 2023-01-17 14:47:38 us=450325   key_pass_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=450440   show_tls_ciphers = DISABLED
# 2023-01-17 14:47:38 us=450555   connect_retry_max = 0
# 2023-01-17 14:47:38 us=450668 Connection profiles [0]:
# 2023-01-17 14:47:38 us=450830   proto = udp
# 2023-01-17 14:47:38 us=450945   local = '[UNDEF]'
# 2023-01-17 14:47:38 us=451057   local_port = '10443'
# 2023-01-17 14:47:38 us=451166   remote = '[UNDEF]'
# 2023-01-17 14:47:38 us=451274   remote_port = '10443'
# 2023-01-17 14:47:38 us=451385   remote_float = DISABLED
# 2023-01-17 14:47:38 us=451499   bind_defined = DISABLED
# 2023-01-17 14:47:38 us=451611   bind_local = ENABLED
# 2023-01-17 14:47:38 us=451725   bind_ipv6_only = DISABLED
# 2023-01-17 14:47:38 us=451834   connect_retry_seconds = 5
# 2023-01-17 14:47:38 us=451951   connect_timeout = 120
# 2023-01-17 14:47:38 us=452097   socks_proxy_server = '[UNDEF]'
# 2023-01-17 14:47:38 us=452209   socks_proxy_port = '[UNDEF]'
# 2023-01-17 14:47:38 us=452322   tun_mtu = 1500
# 2023-01-17 14:47:38 us=452431   tun_mtu_defined = ENABLED
# 2023-01-17 14:47:38 us=452543   link_mtu = 1500
# 2023-01-17 14:47:38 us=452654   link_mtu_defined = DISABLED
# 2023-01-17 14:47:38 us=452766   tun_mtu_extra = 0
# 2023-01-17 14:47:38 us=452880   tun_mtu_extra_defined = DISABLED
# 2023-01-17 14:47:38 us=452993   mtu_discover_type = -1
# 2023-01-17 14:47:38 us=453104   fragment = 0
# 2023-01-17 14:47:38 us=453216   mssfix = 1450
# 2023-01-17 14:47:38 us=453326   explicit_exit_notification = 0
# 2023-01-17 14:47:38 us=453437   tls_auth_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=453552   key_direction = not set
# 2023-01-17 14:47:38 us=453666   tls_crypt_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=453779   tls_crypt_v2_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=453891 Connection profiles END
# 2023-01-17 14:47:38 us=454004   remote_random = DISABLED
# 2023-01-17 14:47:38 us=454115   ipchange = '[UNDEF]'
# 2023-01-17 14:47:38 us=454227   dev = 'tun0'
# 2023-01-17 14:47:38 us=454446   dev_type = '[UNDEF]'
# 2023-01-17 14:47:38 us=454554   dev_node = '[UNDEF]'
# 2023-01-17 14:47:38 us=454664   lladdr = '[UNDEF]'
# 2023-01-17 14:47:38 us=454774   topology = 1
# 2023-01-17 14:47:38 us=454883   ifconfig_local = '10.8.0.1'
# 2023-01-17 14:47:38 us=454997   ifconfig_remote_netmask = '10.8.0.2'
# 2023-01-17 14:47:38 us=455111   ifconfig_noexec = DISABLED
# 2023-01-17 14:47:38 us=455225   ifconfig_nowarn = DISABLED
# 2023-01-17 14:47:38 us=455339   ifconfig_ipv6_local = '[UNDEF]'
# 2023-01-17 14:47:38 us=455575   ifconfig_ipv6_netbits = 0
# 2023-01-17 14:47:38 us=455689   ifconfig_ipv6_remote = '[UNDEF]'
# 2023-01-17 14:47:38 us=455802   shaper = 0
# 2023-01-17 14:47:38 us=455912   mtu_test = 0
# 2023-01-17 14:47:38 us=456022   mlock = DISABLED
# 2023-01-17 14:47:38 us=456135   keepalive_ping = 10
# 2023-01-17 14:47:38 us=456249   keepalive_timeout = 120
# 2023-01-17 14:47:38 us=456362   inactivity_timeout = 0
# 2023-01-17 14:47:38 us=456493   inactivity_minimum_bytes = 0
# 2023-01-17 14:47:38 us=456608   ping_send_timeout = 10
# 2023-01-17 14:47:38 us=456723   ping_rec_timeout = 240
# 2023-01-17 14:47:38 us=456837   ping_rec_timeout_action = 2
# 2023-01-17 14:47:38 us=456945   ping_timer_remote = DISABLED
# 2023-01-17 14:47:38 us=457056   remap_sigusr1 = 0
# 2023-01-17 14:47:38 us=457163   persist_tun = ENABLED
# 2023-01-17 14:47:38 us=457274   persist_local_ip = DISABLED
# 2023-01-17 14:47:38 us=457384   persist_remote_ip = DISABLED
# 2023-01-17 14:47:38 us=457494   persist_key = ENABLED
# 2023-01-17 14:47:38 us=457604   passtos = DISABLED
# 2023-01-17 14:47:38 us=457771   resolve_retry_seconds = 1000000000
# 2023-01-17 14:47:38 us=457882   resolve_in_advance = DISABLED
# 2023-01-17 14:47:38 us=457995   username = 'nobody'
# 2023-01-17 14:47:38 us=458157   groupname = 'nobody'
# 2023-01-17 14:47:38 us=458273   chroot_dir = '[UNDEF]'
# 2023-01-17 14:47:38 us=458384   cd_dir = '[UNDEF]'
# 2023-01-17 14:47:38 us=458496   writepid = '[UNDEF]'
# 2023-01-17 14:47:38 us=458608   up_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=458721   down_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=458830   down_pre = DISABLED
# 2023-01-17 14:47:38 us=458939   up_restart = DISABLED
# 2023-01-17 14:47:38 us=459054   up_delay = DISABLED
# 2023-01-17 14:47:38 us=459165   daemon = DISABLED
# 2023-01-17 14:47:38 us=459275   inetd = 0
# 2023-01-17 14:47:38 us=459383   log = ENABLED
# 2023-01-17 14:47:38 us=459498   suppress_timestamps = DISABLED
# 2023-01-17 14:47:38 us=459608   machine_readable_output = DISABLED
# 2023-01-17 14:47:38 us=459717   nice = 0
# 2023-01-17 14:47:38 us=459824   verbosity = 4
# 2023-01-17 14:47:38 us=459931   mute = 0
# 2023-01-17 14:47:38 us=460039   gremlin = 0
# 2023-01-17 14:47:38 us=460149   status_file = '/var/log/openvpn-status.log'
# 2023-01-17 14:47:38 us=460258   status_file_version = 1
# 2023-01-17 14:47:38 us=460370   status_file_update_freq = 60
# 2023-01-17 14:47:38 us=460480   occ = ENABLED
# 2023-01-17 14:47:38 us=460592   rcvbuf = 0
# 2023-01-17 14:47:38 us=460704   sndbuf = 0
# 2023-01-17 14:47:38 us=460836   sockflags = 0
# 2023-01-17 14:47:38 us=461055   fast_io = DISABLED
# 2023-01-17 14:47:38 us=461165   comp.alg = 2
# 2023-01-17 14:47:38 us=461279   comp.flags = 1
# 2023-01-17 14:47:38 us=461394   route_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=461507   route_default_gateway = '[UNDEF]'
# 2023-01-17 14:47:38 us=461620   route_default_metric = 0
# 2023-01-17 14:47:38 us=461733   route_noexec = DISABLED
# 2023-01-17 14:47:38 us=461848   route_delay = 0
# 2023-01-17 14:47:38 us=461964   route_delay_window = 30
# 2023-01-17 14:47:38 us=462076   route_delay_defined = DISABLED
# 2023-01-17 14:47:38 us=462189   route_nopull = DISABLED
# 2023-01-17 14:47:38 us=462305   route_gateway_via_dhcp = DISABLED
# 2023-01-17 14:47:38 us=462418   allow_pull_fqdn = DISABLED
# 2023-01-17 14:47:38 us=462541   route 10.8.0.0/255.255.255.192/default (not set)/default (not set)
# 2023-01-17 14:47:38 us=462659   management_addr = '[UNDEF]'
# 2023-01-17 14:47:38 us=462775   management_port = '[UNDEF]'
# 2023-01-17 14:47:38 us=462890   management_user_pass = '[UNDEF]'
# 2023-01-17 14:47:38 us=463008   management_log_history_cache = 250
# 2023-01-17 14:47:38 us=463124   management_echo_buffer_size = 100
# 2023-01-17 14:47:38 us=463240   management_write_peer_info_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=463357   management_client_user = '[UNDEF]'
# 2023-01-17 14:47:38 us=463471   management_client_group = '[UNDEF]'
# 2023-01-17 14:47:38 us=463587   management_flags = 0
# 2023-01-17 14:47:38 us=463700   shared_secret_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=463812   key_direction = not set
# 2023-01-17 14:47:38 us=463928   ciphername = 'BF-CBC'
# 2023-01-17 14:47:38 us=464043   ncp_enabled = ENABLED
# 2023-01-17 14:47:38 us=464161   ncp_ciphers = 'AES-256-GCM:AES-128-GCM'
# 2023-01-17 14:47:38 us=464277   authname = 'SHA1'
# 2023-01-17 14:47:38 us=464390   prng_hash = 'SHA1'
# 2023-01-17 14:47:38 us=464505   prng_nonce_secret_len = 16
# 2023-01-17 14:47:38 us=464618   keysize = 0
# 2023-01-17 14:47:38 us=464732   engine = DISABLED
# 2023-01-17 14:47:38 us=464845   replay = ENABLED
# 2023-01-17 14:47:38 us=464979   mute_replay_warnings = DISABLED
# 2023-01-17 14:47:38 us=465097   replay_window = 64
# 2023-01-17 14:47:38 us=465212   replay_time = 15
# 2023-01-17 14:47:38 us=465326   packet_id_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=465436   test_crypto = DISABLED
# 2023-01-17 14:47:38 us=465588   tls_server = ENABLED
# 2023-01-17 14:47:38 us=465700   tls_client = DISABLED
# 2023-01-17 14:47:38 us=465816   ca_file = '/etc/openvpn/keys/ca.crt'
# 2023-01-17 14:47:38 us=465930   ca_path = '[UNDEF]'
# 2023-01-17 14:47:38 us=466042   dh_file = '/etc/openvpn/dh.pem'
# 2023-01-17 14:47:38 us=466155   cert_file = '/etc/openvpn/keys/issued/vpnserver.crt'
# 2023-01-17 14:47:38 us=466274   extra_certs_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=466389   priv_key_file = '/etc/openvpn/keys/private/vpnserver.key'
# 2023-01-17 14:47:38 us=466506   pkcs12_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=466620   cipher_list = '[UNDEF]'
# 2023-01-17 14:47:38 us=466737   cipher_list_tls13 = '[UNDEF]'
# 2023-01-17 14:47:38 us=466853   tls_cert_profile = '[UNDEF]'
# 2023-01-17 14:47:38 us=467071   tls_verify = '[UNDEF]'
# 2023-01-17 14:47:38 us=467184   tls_export_cert = '[UNDEF]'
# 2023-01-17 14:47:38 us=467296   verify_x509_type = 0
# 2023-01-17 14:47:38 us=467412   verify_x509_name = '[UNDEF]'
# 2023-01-17 14:47:38 us=467528   crl_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=467640   ns_cert_type = 0
# 2023-01-17 14:47:38 us=467753   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=467870   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=467982   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468096   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468251   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468364   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468480   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468593   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468708   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468821   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=468934   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=469045   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=469160   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=469294   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=469407   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=469521   remote_cert_ku[i] = 0
# 2023-01-17 14:47:38 us=469637   remote_cert_eku = '[UNDEF]'
# 2023-01-17 14:47:38 us=469750   ssl_flags = 0
# 2023-01-17 14:47:38 us=469864   tls_timeout = 2
# 2023-01-17 14:47:38 us=469978   renegotiate_bytes = -1
# 2023-01-17 14:47:38 us=470094   renegotiate_packets = 0
# 2023-01-17 14:47:38 us=470211   renegotiate_seconds = 3600
# 2023-01-17 14:47:38 us=470324   handshake_window = 60
# 2023-01-17 14:47:38 us=470440   transition_window = 3600
# 2023-01-17 14:47:38 us=470553   single_session = DISABLED
# 2023-01-17 14:47:38 us=470668   push_peer_info = DISABLED
# 2023-01-17 14:47:38 us=470781   tls_exit = DISABLED
# 2023-01-17 14:47:38 us=470897   tls_crypt_v2_metadata = '[UNDEF]'
# 2023-01-17 14:47:38 us=471026   server_network = 10.8.0.0
# 2023-01-17 14:47:38 us=471159   server_netmask = 255.255.255.192
# 2023-01-17 14:47:38 us=471437   server_network_ipv6 = ::
# 2023-01-17 14:47:38 us=471554   server_netbits_ipv6 = 0
# 2023-01-17 14:47:38 us=471684   server_bridge_ip = 0.0.0.0
# 2023-01-17 14:47:38 us=471811   server_bridge_netmask = 0.0.0.0
# 2023-01-17 14:47:38 us=471936   server_bridge_pool_start = 0.0.0.0
# 2023-01-17 14:47:38 us=472061   server_bridge_pool_end = 0.0.0.0
# 2023-01-17 14:47:38 us=472177   push_entry = 'route fa1c0n.ddns.net 255.255.255.255'
# 2023-01-17 14:47:38 us=472295   push_entry = 'route 10.8.0.0 255.255.255.192'
# 2023-01-17 14:47:38 us=472412   push_entry = 'topology net30'
# 2023-01-17 14:47:38 us=472525   push_entry = 'ping 10'
# 2023-01-17 14:47:38 us=472637   push_entry = 'ping-restart 120'
# 2023-01-17 14:47:38 us=472754   ifconfig_pool_defined = ENABLED
# 2023-01-17 14:47:38 us=472884   ifconfig_pool_start = 10.8.0.4
# 2023-01-17 14:47:38 us=473011   ifconfig_pool_end = 10.8.0.59
# 2023-01-17 14:47:38 us=473136   ifconfig_pool_netmask = 0.0.0.0
# 2023-01-17 14:47:38 us=473400   ifconfig_pool_persist_filename = '/var/log/openvpn/ipp.txt'
# 2023-01-17 14:47:38 us=473603   ifconfig_pool_persist_refresh_freq = 600
# 2023-01-17 14:47:38 us=474006   ifconfig_ipv6_pool_defined = DISABLED
# 2023-01-17 14:47:38 us=474137   ifconfig_ipv6_pool_base = ::
# 2023-01-17 14:47:38 us=474252   ifconfig_ipv6_pool_netbits = 0
# 2023-01-17 14:47:38 us=474368   n_bcast_buf = 256
# 2023-01-17 14:47:38 us=474483   tcp_queue_limit = 64
# 2023-01-17 14:47:38 us=474603   real_hash_size = 256
# 2023-01-17 14:47:38 us=474719   virtual_hash_size = 256
# 2023-01-17 14:47:38 us=474832   client_connect_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=474947   learn_address_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=475066   client_disconnect_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=475244   client_config_dir = '[UNDEF]'
# 2023-01-17 14:47:38 us=475361   ccd_exclusive = DISABLED
# 2023-01-17 14:47:38 us=475478   tmp_dir = '/tmp'
# 2023-01-17 14:47:38 us=475591   push_ifconfig_defined = DISABLED
# 2023-01-17 14:47:38 us=475720   push_ifconfig_local = 0.0.0.0
# 2023-01-17 14:47:38 us=475844   push_ifconfig_remote_netmask = 0.0.0.0
# 2023-01-17 14:47:38 us=475961   push_ifconfig_ipv6_defined = DISABLED
# 2023-01-17 14:47:38 us=476088   push_ifconfig_ipv6_local = ::/0
# 2023-01-17 14:47:38 us=476210   push_ifconfig_ipv6_remote = ::
# 2023-01-17 14:47:38 us=476323   enable_c2c = ENABLED
# 2023-01-17 14:47:38 us=476436   duplicate_cn = ENABLED
# 2023-01-17 14:47:38 us=476547   cf_max = 0
# 2023-01-17 14:47:38 us=476664   cf_per = 0
# 2023-01-17 14:47:38 us=476779   max_clients = 1024
# 2023-01-17 14:47:38 us=476898   max_routes_per_client = 256
# 2023-01-17 14:47:38 us=477012   auth_user_pass_verify_script = '[UNDEF]'
# 2023-01-17 14:47:38 us=477126   auth_user_pass_verify_script_via_file = DISABLED
# 2023-01-17 14:47:38 us=477244   auth_token_generate = DISABLED
# 2023-01-17 14:47:38 us=477359   auth_token_lifetime = 0
# 2023-01-17 14:47:38 us=477700   auth_token_secret_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=477819   port_share_host = '[UNDEF]'
# 2023-01-17 14:47:38 us=477935   port_share_port = '[UNDEF]'
# 2023-01-17 14:47:38 us=478045   vlan_tagging = DISABLED
# 2023-01-17 14:47:38 us=478276   vlan_accept = all
# 2023-01-17 14:47:38 us=478392   vlan_pvid = 1
# 2023-01-17 14:47:38 us=478506   client = DISABLED
# 2023-01-17 14:47:38 us=478621   pull = DISABLED
# 2023-01-17 14:47:38 us=478740   auth_user_pass_file = '[UNDEF]'
# 2023-01-17 14:47:38 us=478885 OpenVPN 2.5.7 i386-unknown-openbsd7.2 [SSL (OpenSSL)] [LZO] [LZ4] [MH/RECVDA] [AEAD] built on Sep 27 2022
# 2023-01-17 14:47:38 us=479170 library versions: LibreSSL 3.6.0, LZO 2.10
# 2023-01-17 14:47:38 us=480080 WARNING: --ifconfig-pool-persist will not work with --duplicate-cn
# 2023-01-17 14:47:38 us=484492 Note: cannot open /var/log/openvpn/ipp.txt for READ/WRITE
# 2023-01-17 14:47:38 us=497484 Diffie-Hellman initialized with 2048 bit key
# 2023-01-17 14:47:38 us=516821 TLS-Auth MTU parms [ L:1622 D:1212 EF:38 EB:0 ET:0 EL:3 ]
# 2023-01-17 14:47:38 us=517833 ROUTE_GATEWAY 10.0.0.1/255.255.255.192 IFACE=vr0
# 2023-01-17 14:47:38 us=518622 TUN/TAP device /dev/tun0 opened
# 2023-01-17 14:47:38 us=518839 Can't get interface info: Inappropriate ioctl for device (errno=25)
# 2023-01-17 14:47:38 us=518969 Can't set interface info: Inappropriate ioctl for device (errno=25)
# 2023-01-17 14:47:38 us=519071 do_ifconfig, ipv4=1, ipv6=0
# 2023-01-17 14:47:38 us=519302 /sbin/ifconfig tun0 10.8.0.1 10.8.0.2 mtu 1500 netmask 255.255.255.255 up
# 2023-01-17 14:47:38 us=531253 /sbin/route add -net 10.8.0.0 -netmask 255.255.255.192 10.8.0.2
# add net 10.8.0.0: gateway 10.8.0.2
# 2023-01-17 14:47:38 us=540742 Data Channel MTU parms [ L:1622 D:1450 EF:122 EB:406 ET:0 EL:3 ]
# 2023-01-17 14:47:38 us=542020 Could not determine IPv4/IPv6 protocol. Using AF_INET
# 2023-01-17 14:47:38 us=542426 Socket Buffers: R=[41600->41600] S=[9216->9216]
# 2023-01-17 14:47:38 us=542840 UDPv4 link local (bound): [AF_INET][undef]:10443
# 2023-01-17 14:47:38 us=542982 UDPv4 link remote: [AF_UNSPEC]
# 2023-01-17 14:47:38 us=543191 GID set to nobody
# 2023-01-17 14:47:38 us=543453 UID set to nobody
# 2023-01-17 14:47:38 us=543593 MULTI: multi_init called, r=256 v=256
# 2023-01-17 14:47:38 us=543986 IFCONFIG POOL IPv4: base=10.8.0.4 size=14
# 2023-01-17 14:47:38 us=544230 IFCONFIG POOL LIST
# 2023-01-17 14:47:38 us=544735 Initialization Sequence Completed
# 2023-01-17 14:49:53 us=637922 MULTI: multi_create_instance called
# 2023-01-17 14:49:53 us=638515 90.129.197.109:48665 Re-using SSL/TLS context
# 2023-01-17 14:49:53 us=638719 90.129.197.109:48665 LZO compression initializing
# 2023-01-17 14:49:53 us=644771 90.129.197.109:48665 Control Channel MTU parms [ L:1622 D:1212 EF:38 EB:0 ET:0 EL:3 ]
# 2023-01-17 14:49:53 us=644947 90.129.197.109:48665 Data Channel MTU parms [ L:1622 D:1450 EF:122 EB:406 ET:0 EL:3 ]
# 2023-01-17 14:49:53 us=645708 90.129.197.109:48665 Local Options String (VER=V4): 'V4,dev-type tun,link-mtu 1542,tun-mtu 1500,proto UDPv4,comp-lzo,auth SHA1,keysize 128,key-method 2,tls-server'
# 2023-01-17 14:49:53 us=645832 90.129.197.109:48665 Expected Remote Options String (VER=V4): 'V4,dev-type tun,link-mtu 1542,tun-mtu 1500,proto UDPv4,comp-lzo,auth SHA1,keysize 128,key-method 2,tls-client'
# 2023-01-17 14:49:53 us=653556 90.129.197.109:48665 TLS: Initial packet from [AF_INET]90.129.197.109:48665, sid=0a38b5ee 40b3d8ce
# 2023-01-17 14:49:54 us=655662 90.129.197.109:48665 VERIFY OK: depth=1, CN=OpenVPN fa1c0n CA
# 2023-01-17 14:49:54 us=657442 90.129.197.109:48665 VERIFY OK: depth=0, CN=client1
# 2023-01-17 14:49:54 us=674692 90.129.197.109:48665 peer info: IV_VER=2.5.4
# 2023-01-17 14:49:54 us=674861 90.129.197.109:48665 peer info: IV_PLAT=mac
# 2023-01-17 14:49:54 us=674985 90.129.197.109:48665 peer info: IV_PROTO=6
# 2023-01-17 14:49:54 us=675102 90.129.197.109:48665 peer info: IV_NCP=2
# 2023-01-17 14:49:54 us=675225 90.129.197.109:48665 peer info: IV_CIPHERS=AES-256-GCM:AES-128-GCM
# 2023-01-17 14:49:54 us=675343 90.129.197.109:48665 peer info: IV_LZ4=1
# 2023-01-17 14:49:54 us=675464 90.129.197.109:48665 peer info: IV_LZ4v2=1
# 2023-01-17 14:49:54 us=675582 90.129.197.109:48665 peer info: IV_LZO=1
# 2023-01-17 14:49:54 us=675705 90.129.197.109:48665 peer info: IV_COMP_STUB=1
# 2023-01-17 14:49:54 us=675824 90.129.197.109:48665 peer info: IV_COMP_STUBv2=1
# 2023-01-17 14:49:54 us=675976 90.129.197.109:48665 peer info: IV_TCPNL=1
# 2023-01-17 14:49:54 us=676107 90.129.197.109:48665 peer info: IV_GUI_VER="net.tunnelblick.tunnelblick_5770_3.8.7a__build_5770)"
# 2023-01-17 14:49:54 us=870766 90.129.197.109:48665 Control Channel: TLSv1.3, cipher TLSv1/SSLv3 TLS_CHACHA20_POLY1305_SHA256, peer certificate: 2048 bit RSA, signature: RSA-SHA256
# 2023-01-17 14:49:54 us=871082 90.129.197.109:48665 [client1] Peer Connection Initiated with [AF_INET]90.129.197.109:48665
# 2023-01-17 14:49:54 us=871566 client1/90.129.197.109:48665 MULTI_sva: pool returned IPv4=10.8.0.6, IPv6=(Not enabled)
# 2023-01-17 14:49:54 us=872317 client1/90.129.197.109:48665 MULTI: Learn: 10.8.0.6 -> client1/90.129.197.109:48665
# 2023-01-17 14:49:54 us=872492 client1/90.129.197.109:48665 MULTI: primary virtual IP for client1/90.129.197.109:48665: 10.8.0.6
# 2023-01-17 14:49:54 us=872885 client1/90.129.197.109:48665 Data Channel: using negotiated cipher 'AES-256-GCM'
# 2023-01-17 14:49:54 us=873111 client1/90.129.197.109:48665 Data Channel MTU parms [ L:1550 D:1450 EF:50 EB:406 ET:0 EL:3 ]
# 2023-01-17 14:49:54 us=876692 client1/90.129.197.109:48665 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
# 2023-01-17 14:49:54 us=876884 client1/90.129.197.109:48665 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
# 2023-01-17 14:49:54 us=877532 client1/90.129.197.109:48665 SENT CONTROL [client1]: 'PUSH_REPLY,route fa1c0n.ddns.net 255.255.255.255,route 10.8.0.0 255.255.255.192,topology net30,ping 10,ping-restart 120,ifconfig 10.8.0.6 10.8.0.5,peer-id 0,cipher AES-256-GCM' (status=1)
# 2023-01-17 14:49:56 us=172468 client1/90.129.197.109:48665 PUSH: Received control message: 'PUSH_REQUEST'
# bash-5.1# ping 10.0.0.1
# PING 10.0.0.1 (10.0.0.1): 56 data bytes
# 64 bytes from 10.0.0.1: icmp_seq=0 ttl=64 time=2.756 ms
# 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.707 ms
# 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.679 ms
# ^C
# --- 10.0.0.1 ping statistics ---
# 3 packets transmitted, 3 packets received, 0.0% packet loss
# round-trip min/avg/max/std-dev = 0.679/1.381/2.756/0.973 ms
