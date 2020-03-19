#!/bin/bash
#checking for all c class  ips
for ip in $(seq 1 254);
do
#pinging all ip and putting 
ping -c 1 192.168.74.${ip} | grep "ttl" 
done
echo “done”
#all ip are discovered which are up
