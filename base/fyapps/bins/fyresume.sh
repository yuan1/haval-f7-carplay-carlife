#!/bin/sh

config=/pps/foryou/system/iphonemode

resume() {
	val=$(awk -F ':' '/bootmode/ {print $3}' $config)

	if [ -n "$val" ]; then
		case $val in
		carbit)
			echo 'fykey:json:{"key":242,"src":"panel","status":"dn","param":0}' >>/pps/foryou/system/key
			;;
		carlife)
			echo 'fykey:json:{"key":241,"src":"panel","status":"dn","param":0}' >>/pps/foryou/system/key
			/base/fyapps/bins/fyrepair.sh carlife
			;;
		carplay)
			echo 'fykey:json:{"key":160,"src":"panel","status":"dn","param":0}' >>/pps/foryou/system/key
			/base/fyapps/bins/fyrepair.sh carplay
			;;
		*)
			echo 'fykey:json:{"key":244,"src":"panel","status":"dn","param":0}' >>/pps/foryou/system/key
			;;
		esac
	else
		echo 'fykey:json:{"key":244,"src":"panel","status":"dn","param":0}' >>/pps/foryou/system/key
	fi
}

resume
