# The following script will install and configure (Linux/Debian 9)
# 1- Open VPN Server listening on port 443 (Https and UDP)
# 2- Nginx server to hide the Open VPN Server behind it, most of the monitoring tools in 
#    the middle (not all) will think that you are browsing a website not a VPN.
# 3- Certbot for Certificates.
# 4- Additional tools and scripts

# Install Certbot for free Https Certificates
echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
apt-get -y update
apt-get -y install certbot -t stretch-backports

# Install the rest of the tools
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get -y install openvpn easy-rsa bridge-utils nginx iptables-persistent

# ============================================================================================
# Initialize an internal certificate server for the VPN logins, not related 
# to the https steps later in this document, these certificates are for user logins.
mkdir /etc/openvpn/easy-rsa/
cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/

wget https://b.stru.ca/OpenVPN/vars -O /etc/openvpn/easy-rsa/vars
cd /etc/openvpn/easy-rsa/
ln -s openssl-1.0.0.cnf openssl.cnf

# Bug fixing
sed -i 's/KEY_ALTNAMES="$KEY_CN"/KEY_ALTNAMES="DNS:${KEY_CN}"/g' /etc/openvpn/easy-rsa/pkitool

source vars
./clean-all

# Build a root certificate
export KEY_NAME="root"
/etc/openvpn/easy-rsa/pkitool --initca

# Make a certificate/private key pair using a locally generated root certificate.
export KEY_NAME="server"
/etc/openvpn/easy-rsa/pkitool --server "server"

./build-dh
openvpn --genkey --secret keys/ta.key

# ============================================================================================
# Configure OPEN VPN
mkdir /etc/openvpn/Users-Settings
mkdir /etc/openvpn/Users-Settings/Https
mkdir /etc/openvpn/Users-Settings/Udp

wget https://b.stru.ca/OpenVPN/server-https.conf -O /etc/openvpn/server-https.conf
wget https://b.stru.ca/OpenVPN/server-udp.conf -O /etc/openvpn/server-udp.conf

# Forward Ip trafic
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p

echo "-A FORWARD -i eth0 -o tun0 -j ACCEPT
-A FORWARD -i eth0 -o tun1 -j ACCEPT
-A FORWARD -i tun0 -o eth0 -j ACCEPT
-A FORWARD -i tun1 -o eth0 -j ACCEPT
-A FORWARD -i eth0 -o tun1 -j ACCEPT
-A FORWARD -i tun1 -o eth0 -j ACCEPT
COMMIT

*nat
:PREROUTING ACCEPT [63:4100]
:INPUT ACCEPT [61:3969]
:OUTPUT ACCEPT [34:2056]

-A POSTROUTING -o eth0 -j MASQUERADE
COMMIT
" >> /etc/iptables/rules.v4

# ============================================================================================
# Configure NginX

wget https://b.stru.ca/OpenVPN/index.html -O /var/www/html/index.html
wget https://b.stru.ca/OpenVPN/https-site.txt -O /etc/nginx/sites-available/https-site.txt
ln -s /etc/nginx/sites-available/https-site.txt /etc/nginx/sites-enabled/https-site.txt
rm /etc/nginx/sites-enabled/default

