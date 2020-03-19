#!/bin/bash

sudo apt-get install default-libmysqlclient-dev mariadb-server mariadb-client libmariadbd-dev libmariadbclient-dev autoconf automake libtool dos2unix unzip --force-yes -y
echo "Changing dir"
cd /tmp
read -p 'enter the url to download barnyard2 package' barnyard
sudo wget $barnyard
unzip barnyard2-master.zip
cd barnyard2-master
sudo ln -s /usr/include/dumbnet.h /usr/include/dnet.h
./autogen.sh
sudo ldconfig
sudo ./configure --with-mysql --with-mysql-libraries=/usr/lib/x86_64-linux-gnu/
sudo make
sudo make install
sudo cp etc/barnyard2.conf /etc/snort/
sudo mkdir /var/log/barnyard2
sudo chown snort:snort /var/log/barnyard2
sudo touch /var/log/snort/barnyard2.waldo
sudo chown snort:snort /var/log/snort/barnyard2.waldo
sudo mysql -e "create database snort" -uroot -proot
sudo mysql -e "create user 'snort'@'localhost' identified by 'root'" -proot
sudo mysql -e "grant select,update,create,delete,insert on snort.* to 'snort'@'localhost'" -proot
sudo mysql -uroot -proot snort < schemas/create_mysql
sudo bash -c 'echo "output database: log, mysql, user=snort password=root dbname=snort host=localhost" >> /etc/snort/barnyard2.conf'
cd ../
read -p "enter the url to download 'create-sidemap.pl' package" sidmap

sudo wget $sidmap

sudo dos2unix create-sidmap.pl
sudo chmod +x create-sidmap.pl
sudo bash -c './create-sidmap.pl /etc/snort/rules > /etc/snort/sid-msg.map'
sudo barnyard2 -u snort -g snort -c /etc/snort/barnyard2.conf -f snort.u2 -w /var/log/snort/barnyard2.waldo -d /var/log/snort

