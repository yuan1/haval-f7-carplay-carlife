#!/bin/sh

usb=/fs/usb0

if [ -f "$usb/install.tar.gz" ]; then
    mount -uw /base

    files=$(tar -tf $usb/install.tar.gz)
    tar -zxf $usb/install.tar.gz -C /
    rm $usb/install.tar.gz
    chown root:nto $files
    chmod 777 $files
fi

sleep 2
mount -ur /base
/base/scripts/reboot
