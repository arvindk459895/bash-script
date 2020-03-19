#!/bin/bash
echo 'nag-server' > /etc/hostname
ip=$(hostname -I | awk -F. '{print $3}')

apt-get update
apt-get install sudo -y 
usermod -aG sudo shuhari

sed -i 's/dhcp/static/g' /etc/network/interfaces
 
echo "address	192.168.$ip.100 
netmask	255.255.255.0 
gateway	192.168.$ip.2 
network	192.168.$ip.0 
broadcast	192.168.$ip.255" >> /etc/network/interfaces

sudo dpkg-reconfigure tzdata
sudo ntpdate -dv pool.ntp.org

sudo apt-get install apache2 apache2-utils autoconf gcc libc6 libgd-dev make php python python3 tree unzip wget -y

cd /tmp

echo enter the path for nagios tar file
read path
wget -q $path

tar -xzf nagios-4.4.5.tar.gz

cd nagios-4.4.5

sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled

sudo make all
sudo make install-groups-users

sudo passwd nagios

sudo usermod -a -G nagios www-data

sudo make install
sudo make install-daemoninit

sudo make install-commandmode

sudo make install-config

sudo make install-webconf

sudo a2enmod rewrite

sudo a2enmod cgi

sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin


sudo systemctl restart apache2
sudo systemctl start nagios

# configure nagios-plugins

sudo apt-get install -y automake autotools-dev bc build-essential dc gawk gettext libmcrypt-dev libnet-snmp-perl libssl-dev snmp



cd /tmp



echo Enter the path for nagios-plugin tar file



read plugin



wget -q $plugin



tar -zxf nagios-plugins-release-2.2.1.tar.gz



cd nagios-plugins-release-2.2.1



sudo ./tools/setup



sudo ./configure



sudo make

sudo make install
sudo reboot
