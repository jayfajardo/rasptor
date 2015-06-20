RaspTor
========

RaspTor implements a Wi-Fi router and a TOR Proxy on a Raspberry Pi.

RaspTor Installer based on the tutorial at http://www.makeuseof.com/tag/build-your-own-safeplug-tor-proxy-box/

 
Presented as a workshop at the GIG Makerspace at re:publica 2015

For more information on the TOR Project, visit http://www.torproject.org 

Requirements
------------


Setup
-----
Copy & paste the following commands into your terminal and follow the commands provided

    curl -fsSL https://raw.github.com/jayfajardo/rasptor/master/setup.sh | sudo sh

Usage
-----
After your Pi reboots, it will broadcast its SSID as `RaspTor`. You can connect to it by using the WPA2 password `raspberry`.

After you have connected to your RaspTor, you can verify that you are routing through the Tor proxy by visiting http://check.torproject.org.




