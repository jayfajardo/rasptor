RaspTor
========

RaspTor implements a Wi-Fi router and a TOR Proxy on a Raspberry Pi.

RaspTor Installer based on the tutorial at http://www.makeuseof.com/tag/build-your-own-safeplug-tor-proxy-box/

 
Presented as a workshop at the GIG Makerspace at re:publica 2015

For more information on the TOR Project, visit http://www.torproject.org 

Requirements
------------

* Raspberry Pi installed with the Raspbian Wheezy image.i You can download the latest image from http://www.raspberrypi.org/downloads (It is recommended that you have a fresh install of Wheezy.)
* An internet connection via an ethernet port/cable.
* A Raspberry Pi compatible USB WiFi adapter (RT5370 based adapters usually work without problems.)

Setup
-----

1. Make sure your Pi is connected to the internet using the ethernet port and log in to your Pi.

2. Clone the repository

    ``git clone https://github.com/jayfajardo/rasptor.git``

3. Go into the local repo.

    `cd rasptor`

4. Run the install script and follow the prompts.

    sudo ./setup.sh

Usage
-----
After your Pi reboots, it will broadcast its SSID as `RaspTor`. You can connect to it by using the WPA2 password `raspberry`.

After you have connected to your RaspTor, you can verify that you are routing through the Tor proxy by visiting http://check.torproject.org.




