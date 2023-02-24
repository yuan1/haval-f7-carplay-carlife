#!/bin/ksh

config=/pps/foryou/system/iphonemode
usbport=1

getusbport ()
{
	val=`awk  -F ':' '/usbport/ {print $3}' $config`
	if [ -n "$val" ]; then
		usbport=$val
		echo "usbport is $usbport"
	fi
}

waitforUSB ()
{
	min=0
	max=$1
	while [ $min -le $max ]
	do
		sleep 0.2
		if [ -d "/dev/io-usb" ]; then
			break;
		fi
		min=`expr $min + 1`
		echo $min
	done
}

waitforUSBout ()
{
	min=0
	max=$1
	while [ $min -le $max ]
	do
		sleep 0.2
		if [ ! -d "/dev/io-usb" ]; then
			break;
		fi
		min=`expr $min + 1`
		echo $min
	done
}

waitforNETout ()
{
	min=0
	max=$1
	while [ $min -le $max ]
	do
		sleep 0.2
		if [ ! -d "/alt" ]; then
			break;
		fi
		min=`expr $min + 1`
		echo $min
	done
}


waitforMMIPODOUT ()
{
	min=0
	max=$1
	while [ $min -le $max ]
	do
		sleep 0.1
		pid=`pidin ar |grep mm-ipod|grep -v grep|awk '{print $1}'`
		if [ $pid -gt 0 ]; then
			echo "had mm-ipod"
		else
			break;
		fi
		min=`expr $min + 1`
		echo $min
	done
}

launcherusbreset ()
{
	#pause carlife.
	echo 'cmd::ModuleControl\ndat:json:{"module":3,"status":0}' > /pps/foryou/carlife/control
	sleep 0.1

	echo '[n]usb_power_status::0' >> /pps/foryou/usbpower/control

	echo "slay usblauncher."
	#slay usblauncher.
	pid=`pidin ar |grep usblauncher|grep swaper|awk '{print $1}'`
	
	if [ $pid -gt 0 ]; then
		slay -f $pid
		echo "slay usblauncher pid:$pid"
	fi
	
	sleep 2 
	waitforUSBout 25
	waitforNETout 25
	
	echo "usblauncher."
	#launcher usb.
	if [ "$2" = "none" ]; then
		usblauncher -S1 -p 2 -d Apple -t -e -s /lib/dll/pubs/ -c /etc/usblauncher/swaper-host-usb.lua
	else
		usblauncher -S1 -p 2 -d Apple -t -e -s /lib/dll/pubs/ -c /etc/usblauncher/$1
	fi
	
	#save nowplaying.
	echo "playingmode::$2" >> $config

	sleep 2.5

	waitforUSB 25
	
	slay -f adb

	echo '[n]usb_power_status::1' >> /pps/foryou/usbpower/control
	
}

launcherusb ()
{
	echo "launcher $1"
	#/proc/boot/timestamp "launcherusb" &
	#slay usblauncher.
	pid=`pidin ar |grep usblauncher|grep swaper|awk '{print $1}'`
	if [ -n "$pid" ]; then
		if [ $pid -gt 0 ]; then
			slay -f -9 $pid
			echo "slay usblauncher pid:$pid"
			sleep 1
		fi
	fi
	#launcher usb.
	if [ "$2" = "none" ]; then
		usblauncher -S1 -p 2  -d Apple -t -e -s /lib/dll/pubs/ -c /etc/usblauncher/swaper-host-usb.lua
	else
		/proc/boot/timestamp "usblauncher" &
		usblauncher -S1 -p 2 -d Apple -t -e -s /lib/dll/pubs/ -c /etc/usblauncher/$1
	fi
	#save nowplaying.
	echo "playingmode::$2" >> $config
	
}

bootmode ()
{
	echo "bootmode"
	#/proc/boot/timestamp "bootmode" &
	
	#get carplay
	val=`awk  -F ':' '/bootmode/ {print $3}' $config`
	if [ -n "$val" ]; then
		case $val in 
			carplay) 
				launcherusb "swaper-otg-carplay.lua" $val
				;;
			carlife) 
				launcherusb "swaper-otg-carlife.lua" $val
				;;
			ipod) 
				launcherusb "swaper-host-ipod.lua" $val
				;;
			auto) 
				launcherusb "swaper-otg-auto.lua" $val
				;;
			weblink) 
				launcherusb "swaper-host-weblink.lua" $val
				;;
            carbit) 
                launcherusb "swaper-otg-carbit.lua" $val
                ;;				
			*)
				launcherusb "none" "none"
				;;
		esac
	else
		launcherusb "swaper-host-ipod.lua" "ipod"
	fi
	#save nowplaying.
	echo "playingmode::$val" >> $config
	
	swaperManager &
}

swapmode ()
{
	echo "swapmod $1"
	mode=$1
	
	if [ "$mode" = "last" ]; then
		val=`awk  -F ':' '/playingmode/ {print $3}' $config`
		if [ -n "$1" ]; then
			mode=$val
		else
			mode=ipod
		fi
	fi
	
	if [ -n "$mode" ]; then
		case $mode in 
			carplay) 
				#echo ""
				launcherusbreset "swaper-otg-carplay.lua" $1
				;;
			carbit)
				#echo 'req:json:{"id":9,"cmd":"launch foryouapp","app":"fycarlife","dat":""}' >> /pps/services/app-launcher
				launcherusbreset "swaper-otg-carbit.lua" $1
				;;
			carlife)
				echo 'req:json:{"id":9,"cmd":"launch foryouapp","app":"fycarlife","dat":""}' >> /pps/services/app-launcher
				launcherusbreset "swaper-otg-carlife.lua" $1
				;;
			ipod) 
				#echo 'req:json:{"id":9,"cmd":"launch foryouapp","app":"ipod","dat":""}' >> /pps/services/app-launcher
				launcherusbreset "swaper-host-ipod.lua" $1
				;;
			iap2) 
				#echo 'req:json:{"id":9,"cmd":"launch foryouapp","app":"fyiap2","dat":""}' >> /pps/services/app-launcher
				launcherusbreset "swaper-host-ipod.lua" ipod
				;;
			auto) 
				#echo 'req:json:{"id":9,"cmd":"launch foryouapp","app":"fyiap2","dat":""}' >> /pps/services/app-launcher
				launcherusbreset "swaper-otg-auto.lua" auto
				;;
			weblink) 
				#echo 'req:json:{"id":9,"cmd":"launch foryouapp","app":"fyweblink","dat":""}' >> /pps/services/app-launcher
				launcherusbreset "swaper-host-weblink.lua" weblink
				;;
			*)
				launcherusbreset "" "none"
				;;
		esac
	fi
	
	if [ "$mode" = "carbit" ]; then
		echo "bootmode::carbit" >> $config
	else
		echo "bootmode::ipod" >> $config
	fi
}

getusbport

if [ $# -eq 0 ]; then
	bootmode
else
	if [ ! -f "/dev/shmem/swtatus" ];then
		touch /dev/shmem/swtatus
		swapmode $1
		rm -f /dev/shmem/swtatus
	fi
fi

