#!/bin/sh

echo "clear carlife.................................."
slay -f mm-getipv6
echo "[n]device:n:0">>/pps/foryou/carlife/iphone
echo "[n]ipv6::0">>/pps/foryou/carlife/iphone
echo "[n]current::none">>/pps/foryou/carlife/iphone

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

