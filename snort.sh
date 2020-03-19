#!/bin/bash

sudo apt-get install bison flex gcc libdnet libdumbnet-dev libnghttp2-dev libluajit-5.1-dev libpcap-dev libpcre3-dev libssl-dev make openssl wget zlib1g-dev -y

read -p "Enter the URL for download daq package(http): " daq

sudo mkdir -p /usr/src/snort_src

cd $_

sudo wget  $daq

sudo tar -zxf daq-2.0.6.tar.gz

cd daq-2.0.6

sudo ./configure

sudo make

sudo make install

cd ..

read -p "Enter the URL for download snort package(http): " snort

sudo wget $snort

sudo tar -zxf snort-2.9.15.tar.gz

cd snort-2.9.15

sudo ./configure --enable-sourcefire
sudo make
sudo make install
sudo ldconfig

sudo ln -s /usr/local/bin/snort /usr/sbin/snort

sudo groupadd snort

sudo useradd snort -r -s /usr/sbin/nologin -c SNORT_IDS -g snort

sudo mkdir -p /etc/snort/rules
sudo mkdir -p /var/log/snort
sudo mkdir -p /usr/local/lib/snort_dynamicrules

sudo cp /usr/src/snort_src/snort-2.9.15/etc/*.conf* /etc/snort


sudo cp /usr/src/snort_src/snort-2.9.15/etc/*.map /etc/snort

sudo touch /etc/snort/rules/{white_list.rules,black_list.rules,local.rules}

sudo chmod -R 5755 /etc/snort/rules
sudo chmod -R 5755 /var/log/snort
sudo chmod -R 5755 /usr/local/lib/snort_dynamicrules

sudo chown -R snort:snort /etc/snort/rules
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules

read -p "Enter the URL for download snort.conf: " snortconf

sudo wget $snortconf

sudo rm -rf /etc/snort/snort.conf

mv snort.cnf snort.conf

sudo cp snort.conf /etc/snort/

sudo snort -T -c /etc/snort/snort.conf

#now write alert rules for  snort in /etc/snort/rules/local.rules
#sudo snort -i ens33 -u snort -g snort -c /etc/snort/snort.conf
