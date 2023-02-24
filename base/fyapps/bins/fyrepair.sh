#!/bin/sh

record=/tmp/last.click

if [ ! -f "$record" ]; then
        echo "0" >$record
        chown root:nto $record
        chmod 777 $record
fi

last=$(cat $record)
now=$(date +%Y%m%d%H%M%S)
let "interval=now-last"
echo "$now" >$record

case $1 in
carlife)
        # 3秒内再次点击才执行
        if [ $interval -lt 3 ]; then
                echo "req:json:{\"id\":1,\"cmd\":\"close foryouapp\",\"app\":\"fycarlife\",\"dat\":\"null\"}" >>/pps/services/app-launcher
                wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carlife.wav
                /base/fyapps/bins/swaper_iphonemode.sh carlife
                /base/fyapps/bins/launchcarlifemanager.sh
        fi
        ;;
carplay)
        if [ $(pidin ar | grep ASRService | grep -v grep | awk '{ print $1 }') ]; then
                slay -f ASRService
        fi
        # 3秒内再次点击才执行
        if [ $interval -lt 3 ]; then
                echo 'req:json:{"id":6460,"cmd":"close mixer","app":"fyasr","dat":"null"}' >>/pps/foryou/navigator/mixer
                echo 'req:json:{"id":6461,"cmd":"close mixer","app":"fynavi","dat":"null"}' >>/pps/foryou/navigator/mixer
                echo 'req:json:{"id":6462,"cmd":"close mixer","app":"fycarlife","dat":"null"}' >>/pps/foryou/navigator/mixer
                echo 'req:json:{"id":6463,"cmd":"close mixer","app":"fycarplay","dat":"null"}' >>/pps/foryou/navigator/mixer

                echo 'req:json:{"id":1,"cmd":"close foryouapp","app":"fycarplay","dat":"null"}' >>/pps/services/app-launcher
                wave -a /dev/snd/pcmPreferred /base/fyapps/bins/mode/carplay.wav
                /base/fyapps/bins/swaper_iphonemode.sh carplay
        fi
        ;;
esac
