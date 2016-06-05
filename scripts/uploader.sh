#!/bin/bash

echo $(date)

if /sbin/ifconfig wlan0 &>/dev/null; then
    jessepi=10.1.1.3
else
    jessepi=zigford.ddns.net
fi

if [ ! $1 == "" ] ; then
    echo Uploading $1
    scp $1 pi@${jessepi}:/home/pi/Pictures/
    if [ $? == 0 ] ; then
        echo upload $1 succesfull. Deleting
        rm $1
    else 
        echo upload of $1 failed
    fi
else
    if /home/pi/lapsPi/scripts/net-config.sh start; then
        if [ $? == 0 ] ; then
    	    find /home/pi/Pictures/*.jpg -exec $0 {} \;
        fi
    else
	echo Could not connect to the network
    fi
    /home/pi/lapsPi/scripts/net-config.sh stop
fi
