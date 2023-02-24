#!/bin/sh

config=/pps/foryou/system/dev_status
carplay_run=0
carlife_run=0

#get carplay
val=$(awk -F ':' '/fycarplay:n/ {print $3}' /pps/foryou/system/dev_status)

if [ $val -eq 1 ]; then
	echo set carplay run
	carplay_run=1
fi

#get carlife
val=$(awk -F ':' '/fycarlife:n/ {print $3}' /pps/foryou/system/dev_status)
if [ $val -eq 1 ]; then
	echo set carlife run
	carlife_run=1
fi

echo swap to $1 from $carplay_run $carlife_run

if [ $carlife_run -eq 0 -a $carplay_run -eq 0 ]; then
	echo "no iphone devices."
	exit
fi

if [ $carlife_run -eq 1 -a $1 = "carlife" ]; then
	echo "carlife no need to swap."
	exit
fi

if [ $carplay_run -eq 1 -a $1 = "carplay" ]; then
	echo "carplay no need to swap."
	exit
fi

if [ $1 = "carlife" ]; then
	echo to carlife
	echo "clear carplay.................................."
	if [ $(cat /pps/foryou/carplay/device | grep audio | gawk -F: '{ print $3 }') -ne 0 ]; then
		echo "show menu now"
		echo "req:json:{\"id\":0,\"cmd\":\"launch foryouapp\",\"app\":\"fyhome\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	else
		echo "req:json:{\"id\":0,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_srcs\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	fi
	if [ $(cat /pps/foryou/system/dev_status | grep fycarplay_phone | gawk -F: '{ print $3 }') -ne 0 ]; then
		echo "end the phone call event"
		echo "[n]fycarplay_phone:n:0" >>/pps/foryou/system/dev_status
	fi
	echo 'req:json:{"id":31631,"cmd":"close mixer","app":"fycarplay","dat":"null"}' >>/pps/foryou/navigator/mixer
	echo "[n]fycarplay:n:0" >>/pps/foryou/system/dev_status
	echo "req:json:{\"id\":3,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_siri\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	echo "req:json:{\"id\":2,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_ring\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	echo "req:json:{\"id\":1,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	echo "req:json:{\"id\":4,\"cmd\":\"close foryouapp\",\"app\":\"fyiperftest\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	echo "req:json:{\"id\":5,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_memo\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	echo "req:json:{\"id\":6,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_facetime\",\"dat\":\"null\"}" >>/pps/services/app-launcher
	echo "restore bt setting"
	cat /pps/foryou/carplay/btsetting | grep fybt_setting >>/pps/foryou/setting/bt_control
	slay -f mm-carplay
	sleep 1
	#val=`awk '/ipv6::0/' /pps/foryou/carlife/iphone`
	SOCK=/alt mm-getipv6 &
	//echo "req:json:{\"id\":1,\"cmd\":\"launch foryouapp\",\"app\":\"fycarlife\",\"dat\":\"null\"}" >>/pps/services/app-launcher
fi

if [ $1 = "carplay" ]; then
	echo to carplay

	slay -f mm-getipv6
	echo "[n]device:n:0" >>/pps/foryou/carlife/iphone
	echo "[n]ipv6::0" >>/pps/foryou/carlife/iphone
	echo "req:json:{\"id\":7,\"cmd\":\"close foryouapp\",\"app\":\"fycarlife\",\"dat\":\"null\"}" >>/pps/services/app-launcher

	echo launch carplay.
	SOCK=/alt mm-carplay --widthsize 199 --heightsize 112 --no-knob --prio 123 --wwidth 1280 --wheight 720 --width 1280 --height 720 --maxfps 30 --enable_disp --label HAVAL --logos --logfile /dev/shmem/mm-carplay.log &
fi
