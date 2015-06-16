#!/bin/bash
#
# RaspTor Installer based on the tutorial at http://www.makeuseof.com/tag/build-your-own-safeplug-tor-proxy-box/
#
# 
# Presented as a workshop at the GIG Makerspace at re:publica 2015

# RaspTor implements a Wi-Fi router and a TOR Proxy on a Raspberry Pi.
#
# REQUIREMENTS
#
#
#
# For more information on the TOR Project, visit http://www.torproject.org 

/bin/echo "RaspTor - configure your Raspberry Pi into a TOR proxy."

/bin/echo "This script will auto-setup a Tor proxy for you. It is recommend that you
run this script on a fresh installation of Raspbian."

read -p "Press [Enter] key to begin.." START

# Set up default variables
IP_ADDRESS="192.168.42.1"
SSID="rasptor" 
WPA2="raspberry"
CHANNEL="6"

# read -p "Enter the IP Address you wish to assign to your RaspTor <${IP_ADDRESS}> :" IP_ADDRESS
read -p "Enter your desired WLAN SSID <${SSID}> :" SSID
read -p "Enter your desired WPA2 key <${WPA2}> :}" WPA2
read -p "Enter your desired WLAN radio channel <${CHANNEL}> :" CHANNEL

/bin/echo "Updating package index.."
/usr/bin/apt-get update -y

/bin/echo "Removing Wolfram Alpha Enginer due to bug. More info:
http://www.raspberrypi.org/phpBB3/viewtopic.php?f=66&t=68263"
/usr/bin/apt-get remove -y wolfram-engine

/bin/echo "Updating out-of-date packages.."
/usr/bin/apt-get upgrade -y

/bin/echo "Downloading and installing various packages.."
/usr/bin/apt-get install -y hostapd isc-dhcp-server tor 


/bin/echo "Configuring DHCP.."

/etc/dhcp/dhcpd.conf <<'dhcp_configuration'
# RaspTor
authoritative;
subnet 192.168.42.0 netmask 255.255.255.0 {
range 192.168.42.10 192.168.42.50;
option broadcast-address 192.168.42.255;
option routers 192.168.42.1;
default-lease-time 600;
max-lease-time 7200;
option domain-name "local";
option domain-name-servers 208.67.222.222, 208.232.220.220;
}
dhcp_configuration

/etc/default/isc-dhcp-server <<'isc_dhcp_configuration'
INTERFACES="wlan0"
isc_dhcp_configuration

/bin/echo "Configuring Interfaces.."
/bin/cat /dev/null > /etc/network/interfaces

/etc/network/interfaces <<'interfaces_configuration'
auto lo

iface lo inet loopback
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet static
  address ${IP_ADDRESS} 
  netmask 255.255.255.0

up iptables-restore < /etc/iptables.ipv4.nat

interfaces_configuration

sudo ifconfig wlan0 $IP_ADDRESS 

/bin/echo "Configuring hostapd.."
/bin/cat /dev/null > /etc/hostapd/hostapd.conf
/etc/hostapd/hostapd.conf <<'hostapd_configuration'
interface=wlan0
driver=nl80211
ssid=${SSID}
hw_mode=g
channel=${CHANNEL}
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=${WPA2}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
hostapd_configuration

/etc/default/hostapd <<'hostapd_default'
DAEMON_CONF="/etc/hostapd/hostapd.conf"
hostapd_default

/bin/echo "Configuring NAT and Routing.."
/etc/sysctl.conf <<'sysctl_configuration'
net.ipv4.ip_forward=1
sysctl_configuration

/bin/echo "Set up routing tables.."
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

/etc/network/interfaces <<'iptables_configuration'
up iptables-restore < /etc/iptables.ipv4.nat
iptables_configuration

/bin/echo "Registering daemons as a service.."
sudo service hostapd start
sudo service isc-dhcp-server start
sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable


/bin/echo "Configuring Tor.."
/bin/cat /dev/null > /etc/tor/torrc_tmp
/etc/tor/torrc <<'tor_configuration_tmp'
Log notice file /var/log/tor/notices.log 
VirtualAddrNetwork 10.192.0.0/10
AutomapHostsSuffixes .onion,.exit 
AutomapHostsOnResolve 1 
TransPort 9040 
TransListenAddress ${IP_ADDRESS} 
DNSPort 53
DNSListenAddress ${IP_ADDRESS} 
tor_configuration_tmp

/bin/cat /etc/tor/torcc >> /etc/tor/torrc_tmp
/bin/cat /etc/tor/torrc_tmp > /etc/tor/torcc

/bin/echo "Configuring routing tables to redirect TCP traffic through TOR.."
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 22 -j REDIRECT --to-ports 22
sudo iptables -t nat -A PREROUTING -i wlan0 -p udp --dport 53 -j REDIRECT --to-ports 53
sudo iptables -t nat -A PREROUTING -i wlan0 -p tcp --syn -j REDIRECT --to-ports 9040

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

/bin/echo "Enable TOR to run on boot.."
sudo update-rc.d tor enable

/bin/echo "Installation complete! Restarting Raspberry Pi.."
sudo shutdown -r now


exit


