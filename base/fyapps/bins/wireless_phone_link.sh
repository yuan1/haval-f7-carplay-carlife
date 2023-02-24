#!/bin/sh
# Setting up environment needed for carplay
export CARPLAY_IFACE_NAME=carplay
export CARPLAY_IFACE_NUM=0
export CARPLAY_IFACE=${CARPLAY_IFACE_NAME}${CARPLAY_IFACE_NUM}
export MDNS_DIRECTLINK_IFACE=${CARPLAY_IFACE}
export mDNSPlatformDefaultProbeCountForTypeUnique=0
if [ ! -d "/var/run/mdnsd" ]; then
        mkdir /var/run/mdnsd;
fi

if [ ! -d "/pps/foryou/carplay" ]; then
        mkdir /pps/foryou/carplay;
fi

if [ ! -d "/pps/foryou/carplay/multiple_devices" ]; then
        mkdir /pps/foryou/carplay/multiple_devices;
fi

if [ ! -d "/pps/foryou/androidauto" ]; then
        mkdir /pps/foryou/androidauto;
fi

# Apple code use i2c99 so need to create a symbolic link
ln -sP /dev/i2c4 /dev/i2c99

echo "Starting MDNS..."
mdnsd
waitfor /var/run/mdnsd/mdnsd.pid

echo "Starting mm-carplay..."
mm-carplay  --widthsize 199 --heightsize 112 --no-knob --prio 63 --wwidth 1280 --wheight 720 --width 1280 --height 720 --maxfps 60 --enable_disp --label HAVAL --logos --logfile /dev/shmem/mm-carplay.log &
#echo "Starting mm-aoa..."
#mm-aoa --maker HAVAL --model CHB027 --year 2019 --humaker ADAYO --humodel RN6RE3 --huswbuild 20180327 --huswversion RN6RE320180327 --vwidth 1280 --vheight 720 --maxfps 60 --wwidth 1280 --wheight 720 --pixelAspectRatio 10000 --logfile /dev/shmem/aoa.log &



