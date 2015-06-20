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

Make sure your Pi is connected to the internet using the ethernet port and log in to your Pi.

Clone the repository

    git clone https://github.com/jayfajardo/rasptor.git

Go into the local repo.

    cd rasptor

Run the install script and follow the prompts.

    sudo ./setup.sh

Usage
-----
After your Pi reboots, it will broadcast the SSID you entered during set up or `RaspTor` if you chose the default. You can connect to it by using the WPA2 password you entered during set up or `raspberry` if you chose the defaul.

After you have connected to your RaspTor, you can verify that you are routing through the Tor proxy by visiting http://check.torproject.org.

Contribute
----------

Fork it and submit a pull request.



