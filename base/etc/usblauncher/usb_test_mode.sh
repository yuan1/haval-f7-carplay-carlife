#!/bin/sh
#out32 0x020c9010 0x18060601
slmctl "stop usbMonitor"
sleep 1
echo "req:json:{\"id\":5,\"cmd\":\"launch foryouapp\",\"app\":\"fyusbtestmode\",\"dat\":\"null\"}" >> /pps/services/app-launcher

