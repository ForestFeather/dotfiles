#!/bin/bash
#################################################################################
# FILE: ~/.screen/traff.sh
# AUTHOR: Collin "Ridayah" O'Connor <ridayah@gmail.com>
# VERSION: 1.0.7
# Our fun little script which reports our traffic at any given time!
#################################################################################

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

#echo "INTERFACE=$INTERFACE"

#TX1=`cat /proc/net/dev | grep "$INTERFACE" | cut -d: -f2 | awk '{print $9}'`
#RX1=`cat /proc/net/dev | grep "$INTERFACE" | cut -d: -f2 | awk '{print $1}'`
#sleep .5
#TX2=`cat /proc/net/dev | grep "$INTERFACE" | cut -d: -f2 | awk '{print $9}'`
#RX2=`cat /proc/net/dev | grep "$INTERFACE" | cut -d: -f2 | awk '{print $1}'`

#echo "OUTPUT: $TX1 $TX2 $RX1 $RX2"

#echo -e "TX: $[ $TX2 - $TX1 ] bytes/s \t RX: $[ $RX2 - $RX1 ] bytes/s"
#UPSPEED="$(echo -e "scale=1 \n(${TX2}-${TX1})*2/1024 " | bc )"
#DOWNSPEED="$(echo -e "scale=1 \n(${RX2}-${RX1})*2/1024 " | bc )"
#echo -e "U:${UPSPEED}k/s D:${DOWNSPEED}k/s"

awk 'BEGIN {file="/proc/net/dev";while(a==a){while(getline<file!=0){if(substr($1,1,4)=="'"$INTERFACE"'"){d=substr($1,6,10);u=$9;printf "%s:%6.1fkd",("'"$INTERFACE"'"),((d-dp)/1024);printf " %6.1fku\n",((u-up)/1024)}};close(file);dp=d;up=u;system("sleep 1")}}'

#awk 'BEGIN {file="/proc/net/dev";dp=0;up=0;u=0;d=0;while(getline<file!=0){if(substr($1,1,4)=="'"$INTERFACE"'"){dp=substr($1,6,10);up=$9;}}close(file);system("sleep 1");while(getline<file!=0){if(substr($1,1,4)=="'"$INTERFACE"'"){d=substr($1,6,10);u=$9;}}close(file);printf "%s:%6.1fkd",("'"$INTERFACE"'"),((d-dp)/1024); printf " %6.1fku\n",((u-up)/1024)}'
#--= the end. =--
