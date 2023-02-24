#!/bin/sh

config=/pps/foryou/system/iphonemode

start() {
	val=$(awk -F ':' '/bootmode/ {print $3}' $config)

	if [ -n "$val" -a $val = "carlife" ]; then
		if [ $(pidin ar | grep CarLifeManager | grep -v grep | awk '{ print $1 }') ]; then
			slay -f CarLifeManager
			sleep 1
		fi
		on -p 60 /base/fyapps/mids/CarLifeManager &
	fi
}

start
