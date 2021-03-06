#prepares the device but does not format the HDD
#intended for when you have a pre-imaged HDD with blockchain installed
#prep OS
sudo apt-get update
#install nano for editing (and ntp to set the system clock - may not be needed for 14.12)
sudo apt-get install -y nano
#sudo apt-get install -y ntp
#sudo service ntp restart
sudo apt-get -y upgrade
#rsync for database backup sync
sudo apt-get install -y rsync
#allow device to generate a new mac
sudo rm /etc/mac #delete mac address so device will geneate new address at 1st boot
#prep btc script
sudo chmod 755 btcsetup.sh
sudo chmod 755 *.sh


#backup /home/linaro directory
rm -rf Templates
rm -rf Arduino
#mkdir /tmp/tmp2
#cp -r /home/linaro/. /tmp/tmp2

#add line to /etc/fstab to mount hdd
echo "mount HDD and setup fstab automount"
sudo echo '/dev/sda1   /home   ext4   defaults  0  2' >> /etc/fstab
#mkdir /home
sudo mount -a
sudo chown -R linaro:linaro /home

#restore files to home directory /home/linaro
#mkdir /home/linaro
#cp -r /tmp/tmp2/. /home/linaro

#swapfile setup
echo "1GB swapfile setup on HDD"
#dd line below not needed if hdd is pre-imaged with swapfile
dd if=/dev/zero of=/home/swapfile bs=1024 count=1048576
sudo chown root:root /home/swapfile
sudo chmod 0600 /home/swapfile
sudo mkswap /home/swapfile
sudo swapon  /home/swapfile
sudo echo '/home/swapfile   none   swap  sw   0  0' >> /etc/fstab

#disable screensaver becuase it uses too much CPU
rm /home/linaro/.config/lxsession/LXDE/autostart
mkdir /home/linaro/.config/
mkdir /home/linaro/.config/lxsession/
mkdir /home/linaro/.config/lxsession/LXDE/
echo "@lxpanel --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
echo "@pcmanfm --desktop --profile LXDE" >> /home/linaro/.config/lxsession/LXDE/autostart
echo "@/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1" >> /home/linaro/.config/lxsession/LXDE/autostart

#change host name
sudo hostname btc
sudo rm /etc/hostname
sudo echo "btc" >> /etc/hostname
sudo rm /etc/hosts
sudo cp /home/linaro/bitcoin-box/setup/hosts /etc/
sudo chown -R linaro:linaro /home

echo "next step:  reboot via sudo reboot"
echo "after reboot, run ./btcsetup.sh"
echo "device setup complete" >> /home/linaro/setup.log
