#!/bin/sh

config=/pps/foryou/system/dev_status
carplay_run=0
carlife_run=0

#get carplay
val=`awk  -F ':' '/fycarplay:n/ {print $3}' /pps/foryou/system/dev_status`

if [ $val -eq 1 ]; then
	echo set carplay run
	carplay_run=1
fi

#get carlife
val=`awk  -F ':' '/fycarlife:n/ {print $3}' /pps/foryou/system/dev_status`
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
		echo "req:json:{\"id\":0,\"cmd\":\"launch foryouapp\",\"app\":\"fyhome\",\"dat\":\"null\"}" >> /pps/services/app-launcher
	fi
	echo "req:json:{\"id\":3,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_siri\",\"dat\":\"null\"}" >> /pps/services/app-launcher
	echo "req:json:{\"id\":1,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay\",\"dat\":\"null\"}" >> /pps/services/app-launcher
	echo "req:json:{\"id\":4,\"cmd\":\"close foryouapp\",\"app\":\"fyiperftest\",\"dat\":\"null\"}" >> /pps/services/app-launcher
	echo "restore bt setting"
	cat /pps/foryou/carplay/btsetting | grep fybt_setting >> /pps/foryou/setting/bt_control
	echo "[n]fycarplay:n:0">>/pps/foryou/system/dev_status 
	echo "[n]fycarplay_phone:n:0">>/pps/foryou/system/dev_status 
	slay -f mm-carplay
	sleep 1
	#val=`awk '/ipv6::0/' /pps/foryou/carlife/iphone`
	SOCK=/alt mm-getipv6 &
	//echo "req:json:{\"id\":1,\"cmd\":\"launch foryouapp\",\"app\":\"fycarlife\",\"dat\":\"null\"}" >> /pps/services/app-launcher
fi

if [ $1 = "carplay" ]; then
	echo to carplay
	
	slay -f mm-getipv6
	echo "[n]device:n:0">>/pps/foryou/carlife/iphone
	echo "[n]ipv6::0">>/pps/foryou/carlife/iphone

	echo launch carplay.
	SOCK=/alt mm-carplay --prio 63 --wwidth 800 --wheight 480 --logfile /dev/shmem/mm-carplay.log &
fi

