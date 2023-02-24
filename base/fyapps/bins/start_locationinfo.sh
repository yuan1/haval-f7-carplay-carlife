#!/bin/sh
echo "start location service for carplay..."

if [ $(pidin ar |grep mm-locationinfo |grep -v grep|awk '{ print $1 }') ]; then
	echo "mm-locationinfo exist, slay and wait..."
	slay -f mm-locationinfo
	sleep 1
fi

/base/fyapps/bins/mm-locationinfo -gyro 3 1 &