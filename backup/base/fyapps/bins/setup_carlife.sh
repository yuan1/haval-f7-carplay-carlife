#!/bin/sh

# Setting up environment needed for carplay
export CARPLAY_IFACE_NAME=carplay
export CARPLAY_IFACE_NUM=0
export CARPLAY_IFACE=${CARPLAY_IFACE_NAME}${CARPLAY_IFACE_NUM}
export MDNS_DIRECTLINK_IFACE=${CARPLAY_IFACE}
if [ ! -d "/var/run/mdnsd" ]; then
        mkdir /var/run/mdnsd;
fi

if [ ! -d "/pps/foryou/carplay" ]; then
        mkdir /pps/foryou/carplay;
fi

# Creating another instance of io-pkt in order to allow the interferance
# of other interfaces for the communication between mdnsd and carplay
echo "Starting /alt/dev/io-pkt..."
io-pkt-v6-hc -ptcpip stacksize=8192,prefix=/alt
# Apple code use i2c99 so need to create a symbolic link
ln -sP /dev/i2c4 /dev/i2c99

echo "Starting MDNS..."
SOCK=/alt mdnsd
waitfor /var/run/mdnsd/mdnsd.pid

echo "Starting mm-ipod..."
mm-ipod -d iap2,config=/etc/mm/iap2.cfg,probe,ppsdir=/pps/services/multimedia/iap2 -a i2c,addr=0x11,path=/dev/i2c4,speed=32000,variant20c -t usbdevice,priority=50,path=/dev/io-usb/io-usb-dcd

sleep 2

echo "start carlife.................................."
SOCK=/alt mm-getipv6 &

