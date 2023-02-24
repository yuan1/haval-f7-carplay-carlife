#!/bin/sh

echo "clear carlife.................................."
slay -f mm-getipv6
echo "[n]device:n:0">>/pps/foryou/carlife/iphone
echo "[n]ipv6::0">>/pps/foryou/carlife/iphone
echo "[n]current::none">>/pps/foryou/carlife/iphone

echo "clear carplay.................................."
if [ $(cat /pps/foryou/carplay/device | grep audio | gawk -F: '{ print $3 }') -ne 0 ]; then
	echo "show menu now"
	echo "req:json:{\"id\":0,\"cmd\":\"launch foryouapp\",\"app\":\"fyhome\",\"dat\":\"null\"}" >> /pps/services/app-launcher
else
	echo "req:json:{\"id\":0,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_srcs\",\"dat\":\"null\"}" >> /pps/services/app-launcher
fi
if [ $(cat /pps/foryou/system/dev_status | grep fycarplay_phone | gawk -F: '{ print $3 }') -ne 0 ]; then
	echo "end the phone call event"
	echo "[n]fycarplay_phone:n:0">>/pps/foryou/system/dev_status
fi
echo 'req:json:{"id":31631,"cmd":"close mixer","app":"fycarplay","dat":"null"}' >> /pps/foryou/navigator/mixer
echo "[n]fycarplay:n:0">>/pps/foryou/system/dev_status
echo "req:json:{\"id\":3,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_siri\",\"dat\":\"null\"}" >> /pps/services/app-launcher
echo "req:json:{\"id\":2,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_ring\",\"dat\":\"null\"}" >> /pps/services/app-launcher
echo "req:json:{\"id\":1,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay\",\"dat\":\"null\"}" >> /pps/services/app-launcher
echo "req:json:{\"id\":4,\"cmd\":\"close foryouapp\",\"app\":\"fyiperftest\",\"dat\":\"null\"}" >> /pps/services/app-launcher
echo "req:json:{\"id\":5,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_memo\",\"dat\":\"null\"}" >> /pps/services/app-launcher
echo "req:json:{\"id\":6,\"cmd\":\"close foryouapp\",\"app\":\"fycarplay_facetime\",\"dat\":\"null\"}" >> /pps/services/app-launcher

echo "slay mm-locationinfo for carplay"
slay -f mm-locationinfo
echo "slay mm-carplay for carplay"
slay -f mm-carplay
echo "slay mm-ipod for carplay"
slay -f mm-ipod
echo "slay mdnsd for carplay"
slay -f mdnsd
echo "ifconfig destroy"
SOCK=/alt ifconfig ${CARPLAY_IFACE} destroy
echo "kill io-pkt-v6-hc for carplay"
kill $(pidin ar | grep io-pkt-v6-hc | grep prefix=/alt | awk '{print $1}')
echo "slay adb for carlife"
slay -f adb
echo "restore bt setting"
cat /pps/foryou/carplay/btsetting | grep fybt_setting >> /pps/foryou/setting/bt_control
