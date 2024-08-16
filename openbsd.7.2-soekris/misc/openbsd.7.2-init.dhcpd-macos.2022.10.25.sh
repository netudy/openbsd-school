#!/bin/sh
echo This is a vodka-bottle-documentation, sorry, no automation at this time, :-/
exit 1

##########################################################
# - init DHCPD MacOS Ventura
##########################################################

sudo bash
cat <<"EOF" > /etc/bootpd.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Subnets</key>
    <array>
        <dict>
            <key>_creator</key>
            <string>com.apple.NetworkSharing</string>
            <key>allocate</key>
            <true/>
            <key>dhcp_domain_name_server</key>
            <array>
                <string>192.168.2.1</string>
            </array>
            <key>dhcp_router</key>
            <string>192.168.2.1</string>
            <key>interface</key>
            <string>bridge100</string>
            <key>lease_max</key>
            <integer>86400</integer>
            <key>lease_min</key>
            <integer>86400</integer>
            <key>name</key>
            <string>192.168.2/24</string>
            <key>net_address</key>
            <string>192.168.2.0</string>
            <key>net_mask</key>
            <string>255.255.255.0</string>
            <key>net_range</key>
            <array>
                <string>192.168.2.2</string>
                <string>192.168.2.254</string>
            </array>
            <key>dhcp_option_66</key>
            <string>192.168.2.1</string>
            <key>dhcp_option_67</key>
            <string>pxeboot</string>
        </dict>
    </array>
    <key>bootp_enabled</key>
    <false/>
    <key>detect_other_dhcp_server</key>
    <array>
        <string>bridge100</string>
    </array>
    <key>dhcp_enabled</key>
    <array>
        <string>bridge100</string>
    </array>
    <key>dhcp_ignore_client_identifier</key>
    <true/>
    <key>ignore_allow_deny</key>
    <array>
        <string>bridge100</string>
    </array>
    <key>use_server_config_for_dhcp_options</key>
    <false/>
</dict>
</plist>
EOF

sudo /bin/launchctl unload -w /System/Library/LaunchDaemons/bootps.plist
sudo /bin/launchctl load -w /System/Library/LaunchDaemons/bootps.plist

