#!/bin/sh
# Setting up environment needed for carplay
export CARPLAY_IFACE_NAME=carplay
export CARPLAY_IFACE_NUM=0
export CARPLAY_IFACE=${CARPLAY_IFACE_NAME}${CARPLAY_IFACE_NUM}
export MDNS_DIRECTLINK_IFACE=${CARPLAY_IFACE}
export mDNSPlatformDefaultProbeCountForTypeUnique=0

if [ ! -d "/var/run/mdnsd" ]; then
        mkdir /var/run/mdnsd
fi

if [ ! -d "/pps/foryou/carplay" ]; then
        mkdir /pps/foryou/carplay
fi

if [ ! -d "/pps/foryou/carplay/multiple_devices" ]; then
        mkdir /pps/foryou/carplay/multiple_devices
fi

# Creating another instance of io-pkt in order to allow the interferance
# of other interfaces for the communication between mdnsd and carplay
echo "Starting /alt/dev/io-pkt..."
io-pkt-v6-hc -i1 -ptcpip stacksize=8192,prefix=/alt
# Apple code use i2c99 so need to create a symbolic link
ln -sP /dev/i2c4 /dev/i2c99

SOCK=/alt mount -Tio-pkt1 -o verbose=0,path=/dev/io-usb/io-usb-dcd,iface_num=1,protocol=ncm,npkt=10,usbdnet_mac=020022446688,mac=8030DCF62528,name=${CARPLAY_IFACE_NAME} devnp-usbdnet.so
SOCK=/alt ifconfig ${CARPLAY_IFACE} up

echo "Starting mm-ipod..."
mm-ipod -d iap2,config=/etc/mm/iap2.cfg,probe,ppsdir=/pps/services/multimedia/iap2 -a i2c,addr=0x11,path=/dev/i2c4,speed=32000,variant20c -t usbdevice,priority=60,path=/dev/io-usb/io-usb-dcd
waitfor /pps/services/multimedia/iap2/location

echo "Starting MDNS..."
SOCK=/alt mdnsd
waitfor /var/run/mdnsd/mdnsd.pid

echo "Starting mm-carplay..."
SOCK=/alt on -C1 mm-carplay --widthsize 199 --heightsize 112 --no-knob --prio 123 --wwidth 1280 --wheight 720 --width 1280 --height 720 --maxfps 30 --enable_disp --label 哈弗 --logos --logfile /dev/shmem/mm-carplay.log &

#restore bt setting
cat /pps/foryou/setting/bt_status | grep fybt_setting >>/pps/foryou/carplay/btsetting
