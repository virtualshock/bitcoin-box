#!/bin/bash
#installs and configures software for bitseed V2
#must run as sudo
#reboot when complete.  Device will have a new mac and ip address

sudo rm /etc/mac
sudo cp /home/linaro/bitcoin-box/.hdd/*.sh /home/linaro
sudo cp $HOME/bitcoin-box/.hdd/bitcoin.conf $HOME/.bitcoin
sudo chown -R linaro:linaro /home/linaro
chmod 755 /home/linaro/*.sh
chmod 755 /home/linaro/bitcoin-box/setup/*sh
chmod 755 /home/linaro/bitcoind
chmod 755 /home/linaro/bitcoin-cli
sudo cp /home/linaro/bitcoin-box/.hdd/safestop.sh /root
sudo mkdir $HOME/.bitseed
sudo cp /home/linaro/bitcoin-box/.hdd/bitseed.conf $HOME/.bitseed
sudo echo "bitcoin" > $HOME/.bitseed/coin
sudo chown -R linaro:linaro $HOME/.gnupg

#install php GUI
#public UI on port 80
#private coontrols on port 81
#sudo ./admin-v2-install.sh
sudo ./admin-v2.1-install.sh
sudo chmod 666 /home/linaro/restartflag

#set serial number
echo "Enter device serial number:"
read serial
echo $serial > /home/linaro/"deviceid-$serial"
echo $serial > /var/www/html/serial
echo $serial > /var/www/onion/serial
sudo chown www-data:www-data /var/www/html/serial
sudo chown www-data:www-data /var/www/onion/serial

#disable screensaver becuase it uses too much CPU
#sudo mv /etc/init/lxdm.conf /etc/init/lxdm.conf.nostart
#rm /home/linaro/.config/lxsession/LXDE/autostart
#echo "@lxpanel --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
#echo "@pcmanfm --desktop --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
#echo "@/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1" >> /home/linaro/.config/lxsession/LXDE/autostart

#dd line below not needed if hdd is pre-imaged with swapfile
echo "setting up swap"
dd if=/dev/zero of=/home/swapfile bs=1024 count=1048576
sudo chown root:root /home/swapfile
sudo chmod 0600 /home/swapfile
sudo mkswap /home/swapfile
sudo swapon  /home/swapfile

echo "211" > /home/linaro/version
sudo chown linaro:linaro /home/linaro/checkupdates.sh
#sudo cp $HOME/bitcoind /usr/local/bin
#sudo cp $HOME/bitcoin-cli /usr/local/bin
gpg --import $HOME/bitcoin-box/.hdd/bitseed-jay.pub
rm bitseed-jay.pub

#Tor respository to get latest version
#sudo echo "deb http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
#sudo echo "deb-src http://deb.torproject.org/torproject.org trusty main" >> /etc/apt/sources.list
#sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 74A941BA219EC810
#sudo apt-get update

#security patch
#sudo echo "deb http://ports.ubuntu.com/ubuntu-ports/ trusty-security main universe" >> /etc/apt/sources.list
#sudo echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ trusty-security main universe" >> /etc/apt/sources.list
#sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com ADCE2AF3A4E0014F
#sudo sed -i '/wiimu/d' /etc/apt/sources.list
#sudo apt-get update
#sudo apt-get install -y libc-dev-bin libc6 libc6-armel libc6-dev
#sleep 5
#sudo dpkg -l libc6 libc6-dev libc6-armel libc-dev-bin >> /home/linaro/bitcoin-box/setup/setup.log
#sudo dpkg -l libc6 libc6-dev libc6-armel libc-dev-bin


sudo chmod u+s /bin/ping
#sudo apt-get install -y ntp
#sudo apt-get install -y libevent-dev
sudo apt-get install -y tor
sudo apt-get -y autoremove
sudo echo "HiddenServiceDir /var/lib/tor/bitseed-service/" >> /etc/tor/torrc
sudo echo "HiddenServicePort 80 127.0.0.1:82" >> /etc/tor/torrc
sudo echo "ControlPort 9051" >> /etc/tor/torrc
sudo echo "CookieAuthentication 1" >> /etc/tor/torrc
sudo usermod -a -G debian-tor linaro 
sudo service tor restart
sleep 5
sudo cat /var/lib/tor/bitseed-service/hostname
echo "quickset done" >> /home/linaro/bitcoin-box/setup/setup.log
