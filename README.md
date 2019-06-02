# Preconfigured-OpenVPN-VM
A set of scripts that automatically create and configure an OpenVPN server end to end.

## Summary

The following script will provide you with:
1. An OpenVPN Server hiding behind Nginx Https installed on Debian Linux 9
2. A second Open VPN server listening to UDP port 443
3. End to end configuration with proper https certificates from Letsencrypt.org

## Details

OpenVPN is a very small and very powerful VPN systems that can link user machines to corporate machines, as well as corporate to corporate, OpenVPN + Linux can configure any type of network traffic that can be configured.

But…. Installing and configuring OpenVPN takes time, a lot of time, so this project is automating the process, a few commands and you should get an end to end configured OpenVPN environment.


## Requirements:

1- A Debian 9 Linux Virtual Machine, Local or on the Cloud

2- A Domain name, example: vpn.example.com pointing to your new OpenVPN VM.
Important: This script needs a domain name not an IP address, otherwise the https certificate step will fail, and that means NginX will fail, and that means OpenVPN will not work, you need a domain name pointing to the VM

3- Open Ports, if you happened to create a Debian 9 Virtual Machine on Google Cloud, make sure ports 80 TCP, and Ports 443 TCP and UDP are open
Note: The script will work with Port 80 opened and Ports 443 closed, but the VPN will not afterword, the ports must be opened and connected to the VM

Again, you need a Debian Virtual machine, connected to the internet, the ports opened, and a DNS entry, domain name, pointing to that machine.

## Installation:

The script is available on GitHub and a copy of the script on b.stru.ca you can download the source and update the script, or you can run it directly from b.stru.ca, both should be ok.

```
wget https://b.stru.ca/OpenVPN/install.sh -O /tmp/vpn-install.sh
chmod +x /tmp/vpn-install.sh
sudo /tmp/vpn-install.sh
```

## To Create a new VPN User

```
/etc/openvpn/vpn-create-user.sh User1
```
