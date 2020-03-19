#!/bin/bash
#Download meta data of any website (only jpg,jpeg,png,gif,pdf) 
a = "https://vyaseducation.org/"
wget -nd -H -p -A jpg,jpeg,png,gif -e robots=off $a
#wget -nd -H -p -A jpg,pdf -e robots=off https://collegedunia.com/university/25726-swami-ramanand-teerth-marathwada-university-srtmun-nanded
#wget -nd -H -p -A pdf -e robots=off 
lynx --dump $a |awk '/http/{print $2}' | grep pdf  > links.txt
#mkdir pdf
#cd pdf
for i in $(cat links.txt) 
do 
wget $i
done

