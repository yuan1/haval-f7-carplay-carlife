#! /bin/sh
#$Addr = $(netstat -rn | grep %carplay0 | grep UHLc | gawk '{print $1}')
case $1 in 
	TCP_UL) 
		echo 'TCP_UL.'
		slay -f iperf
		on -p 100r -d iperf -V -s -i 1 -w 128k -p 5001
		;;
	UDP_UL_50) 
		echo 'UDP_UL_50.'
		slay -f iperf
		on -p 100r -d iperf -V -s -i 1 -w 128k -p 5001 -u
		;;
	UDP_UL_100) 
		echo 'UDP_UL_100.'
		slay -f iperf
		on -p 100r -d iperf -V -s -i 1 -w 128k -p 5001 -u
		;;
	TCP_DL) 
		echo 'TCP_DL.'
		slay -f iperf
		on -p 200r -d iperf -V -i 1 -w 128k -c $(netstat -rn | grep %carplay0 | grep UHLc | gawk '{print $1}') -p 5001
		;;
	UDP_DL_50) 
		echo 'UDP_DL_50.'
		slay -f iperf
		on -p 200r -d iperf -V -i 1 -w 128k -c $(netstat -rn | grep %carplay0 | grep UHLc | gawk '{print $1}') -p 5001 -l 1448 -u -b 50m	
		;;
	UDP_DL_100)
		echo 'UDP_DL_100.'
		slay -f iperf
		on -p 200r -d iperf -V -i 1 -w 128k -c $(netstat -rn | grep %carplay0 | grep UHLc | gawk '{print $1}') -p 5001 -l 1448 -u -b 220m
		;;
	*)
		echo 'return to start page'
		slay -f iperf
		;;
esac
