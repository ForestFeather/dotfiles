#!/bin/bash

# The second half of this script was pulled from: http://www.madmadmod.com/sysadmin/54-how-to-get-the-current-network-bandwidth-usage-on-linux.html
# The first half was pulled from traff.sh

IFS='\n'
IFOUTPUT=( $(/sbin/ifconfig -s) )
COUNTER=0
INTERFACE=`
echo -e "$IFOUTPUT" | while read line; do
	if [ "$COUNTER" = "0" ]; then 
		COUNTER=$(expr $COUNTER + 1)
	else
		INTERFAC=$(echo $line | awk '{print $1}')
		RX=$(echo $line | awk '{print $4}')
		if [ "$RX" -gt "0" ]; then 
			echo "$INTERFAC"
			exit 1 
		fi
	fi
done`       

R1=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
T1=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
sleep 1
R2=`cat /sys/class/net/$INTERFACE/statistics/rx_bytes`
T2=`cat /sys/class/net/$INTERFACE/statistics/tx_bytes`
TBPS=`expr $T2 - $T1`
RBPS=`expr $R2 - $R1`
TKBPS=`expr $TBPS / 1024`
RKBPS=`expr $RBPS / 1024`
echo "$INTERFACE: $TKBPS ku $RKBPS kd"
