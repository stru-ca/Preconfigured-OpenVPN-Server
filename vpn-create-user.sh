#!/bin/bash
UserName=${1}
cd /etc/openvpn/easy-rsa/
source vars $UserName
export KEY_NAME=$UserName
/etc/openvpn/easy-rsa/pkitool $UserName
cd .

cat /etc/openvpn/Users-Certificates/Vpn-Client-Template-Https.conf \
    <(echo -e '<ca>') \
    /etc/openvpn/easy-rsa/keys/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    /etc/openvpn/easy-rsa/keys/$UserName.crt \
    <(echo -e '</cert>\n<key>') \
    /etc/openvpn/easy-rsa/keys/$UserName.key \
    <(echo -e '</key>\n<tls-auth>') \
    /etc/openvpn/easy-rsa/keys/ta.key \
    <(echo -e '</tls-auth>') \
    > /etc/openvpn/Users-Certificates/$UserName-Https.ovpn

cat /etc/openvpn/Users-Certificates/Vpn-Client-Template-Udp.conf \
    <(echo -e '<ca>') \
    /etc/openvpn/easy-rsa/keys/ca.crt \
    <(echo -e '</ca>\n<cert>') \
    /etc/openvpn/easy-rsa/keys/$UserName.crt \
    <(echo -e '</cert>\n<key>') \
    /etc/openvpn/easy-rsa/keys/$UserName.key \
    <(echo -e '</key>\n<tls-auth>') \
    /etc/openvpn/easy-rsa/keys/ta.key \
    <(echo -e '</tls-auth>') \
    > /etc/openvpn/Users-Certificates/$UserName-Udp.ovpn

echo "Please send these 2 files to the user: "
echo "/etc/openvpn/Users-Certificates/$UserName-Https.ovpn"
echo "/etc/openvpn/Users-Certificates/$UserName-Udp.ovpn"
