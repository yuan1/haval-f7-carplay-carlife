#!/bin/sh

config=/pps/foryou/system/iphonemode

swapmode() {
	val=$(awk -F ':' '/bootmode/ {print $3}' $config)

	if [ -n "$val" ]; then
		case $val in
		ipod)
			wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carbit.wav
			/base/fyapps/bins/swaper_iphonemode.sh carbit
			;;
		carbit)
			# echo 'fykey:json:{"key":243,"src":"panel","status":"dn","param":0}' >>/pps/foryou/system/key
			wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carlife.wav
			/base/fyapps/bins/swaper_iphonemode.sh carlife
			/base/fyapps/bins/launchcarlifemanager.sh
			;;
		carlife)
			if [ $(pidin ar | grep ASRService | grep -v grep | awk '{ print $1 }') ]; then
				slay -f ASRService
			fi
			if [ $(pidin ar | grep CarLifeManager | grep -v grep | awk '{ print $1 }') ]; then
				slay -f CarLifeManager
			fi
			if [ $(pidin ar | grep mm-getipv6 | grep -v grep | awk '{ print $1 }') ]; then
				slay -f mm-getipv6
				echo "[n]device:n:0" >>/pps/foryou/carlife/iphone
				echo "[n]ipv6::0" >>/pps/foryou/carlife/iphone
			fi
			wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carplay.wav
			/base/fyapps/bins/swaper_iphonemode.sh carplay
			echo "req:json:{\"id\":0,\"cmd\":\"close foryouapp\",\"app\":\"fycarlife\",\"dat\":\"null\"}" >>/pps/services/app-launcher
			;;
		carplay)
			wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/ipod.wav
			/base/fyapps/bins/swaper_iphonemode.sh ipod
			echo "req:json:{\"id\":0,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay\",\"dat\":\"null\"}" >>/pps/services/app-launcher
			;;
		*)
			wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carbit.wav
			/base/fyapps/bins/swaper_iphonemode.sh carbit
			;;
		esac
	else
		wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carbit.wav
		/base/fyapps/bins/swaper_iphonemode.sh carbit
	fi
}

swapmode
