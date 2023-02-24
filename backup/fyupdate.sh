#!/bin/sh

usb=/fs/usb0

if [ -f "$usb/install.tar.gz" ]; then
    mount -uw /base

    files=$(tar -tf $usb/install.tar.gz)
    tar -zxf $usb/install.tar.gz -C /
    rm $usb/install.tar.gz
    chown root:nto $files
    chmod 777 $files
    rm -rf /base/etc/mm/aoa.cfg
    rm -rf /base/etc/system/config/debug_host.conf
    rm -rf /base/etc/dhcpd_urndis.leases
    rm -rf /base/etc/dhcpd_usbdnet.leases
    rm -rf /base/etc/wpa_pps.conf
    rm -rf /base/fyapps/apps/CarplayApp
    rm -rf /base/fyapps/apps/iperftestguide
    rm -rf /base/fyapps/bins/clear_wireless.sh
    rm -rf /base/fyapps/bins/fymode.sh
    rm -rf /base/fyapps/bins/fyrepair.sh
    rm -rf /base/fyapps/bins/fyresume.sh
    rm -rf /base/fyapps/bins/iperf
    rm -rf /base/fyapps/bins/iperf_test.sh
    rm -rf /base/fyapps/bins/launchasrservice.sh
    rm -rf /base/fyapps/bins/launchcarlifemanager.sh
    rm -rf /base/fyapps/bins/usbtestmode
    rm -rf /base/fyapps/bins/wireless_phone_link.sh
    rm -rf /base/fyapps/bins/mode
    rm -rf /base/fyapps/datas/process_monitor.cfg
    rm -rf /base/fyapps/etc/BasicLogConfig.json
    rm -rf /base/fyapps/etc/CarLifeLibConfig.json
    rm -rf /base/fyapps/libs/libaoa.so
    rm -rf /base/fyapps/libs/libAudioConverter.so
    rm -rf /base/fyapps/libs/libbasic.so
    rm -rf /base/fyapps/libs/libcarlifevehicle.so.1.0.3
    rm -rf /base/fyapps/libs/libCoreUtils.so
    rm -rf /base/fyapps/libs/libdr2nmea.so
    rm -rf /base/fyapps/libs/libfaad.so.2
    rm -rf /base/fyapps/libs/libgestures.so.1
    rm -rf /base/fyapps/libs/libopus.so.6
    rm -rf /base/fyapps/libs/libScreenStream.so
    rm -rf /base/fyapps/rccs/icon_120x120blue.png
    rm -rf /base/fyapps/rccs/icon_120x120.png
    rm -rf /base/fyapps/rccs/icon_180x180blue.png
    rm -rf /base/fyapps/rccs/icon_180x180.png
    rm -rf /base/fyapps/rccs/icon_256x256blue.png
    rm -rf /base/fyapps/rccs/icon_256x256.png
    rm -rf /base/fyapps/rccs/icon.png
    rm -rf /base/fyapps/rccs/iperftestguide0.PNG
    rm -rf /base/fyapps/rccs/iperftestguide1.PNG
    rm -rf /base/fyapps/rccs/iperftestguide2.PNG
    rm -rf /base/fyapps/rccs/iperftestguide3.PNG
    rm -rf /base/fyapps/rccs/iperftestguide4.PNG
    rm -rf /base/fyapps/rccs/iperftestguide5.PNG
    rm -rf /base/fyapps/rccs/iperftestguide6.PNG
    rm -rf /base/fyapps/rccs/usbtestmode0.png
    rm -rf /base/fyapps/rccs/usbtestmode1.png
    rm -rf /base/fyapps/rccs/usbtestmode2.png
    rm -rf /base/usr/lib/graphics/iMX6X/graphics.conf
fi

sleep 2
mount -ur /base
/base/scripts/reboot
