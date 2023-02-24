#!/bin/sh

config=/pps/foryou/system/iphonemode

start() {
	val=$(awk -F ':' '/bootmode/ {print $3}' $config)

	if [ ! -n "$val" -o "$val" != "carplay" ]; then
		if [ $(pidin ar | grep ASRService | grep -v grep | awk '{ print $1 }') ]; then
			slay -f ASRService
			sleep 1
		fi
		on -p 60 /base/fyapps/mids/ASRService &
	fi
}

start
