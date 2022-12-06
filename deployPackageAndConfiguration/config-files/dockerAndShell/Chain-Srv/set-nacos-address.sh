#!/bin/bash
read -p "Please enter the nacos server ip: " NACOSADDRESS
read -p "Please enter the nacos server port: " NACOSPORTS
START_SCRIPT=$(find /bsn -name start.sh)
for i in ${START_SCRIPT}; do
    echo "Absolute path: "$i
    SOURCENACOS_ADDRESS=$(cat $i | grep -i "nacos.config.server-addr" | awk -F"=" '{print $NF}')
    sed -i "s@${SOURCENACOS_ADDRESS}@${NACOSADDRESS}:${NACOSPORTS}@g" $i;cat $i | grep nacos.config.server-addr;echo
done