#!/bin/bash
#To check which host is UP in your network
for ip in $(seq 1 254);
do
ping -c 1 192.168.74.${ip} > /dev/null 
if [ $? -eq 0 ]; then
echo “192.168.74.$ip is UP”
fi
done
echo “done”
