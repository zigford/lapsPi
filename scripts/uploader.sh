#!/bin/bash

if ifconfig wlan0 &>/dev/null; then
    jessepi=10.1.1.250
else
    jessepi=zigford.ddns.net
fi

if [ ! $1 == "" ] ; then
    echo Uploading $1
    #DIR=$(echo $1 |awk -F '/' '{print $5}')
    #ssh pi@${jessepi} mkdir /home/pi/pics/${DIR} 2>/dev/null
    scp $1 pi@${jessepi}:/home/pi/pictures/
    if [ $? == 0 ] ; then
        echo upload $1 succesfull. Deleting
        rm $1
    else 
        echo upload of $1 failed
    fi
else
    /home/pi/scripts/net-config.sh start
    if [ $? == 0 ] ; then
    	find /home/pi/pictures -name *.jpg -exec $0 {} \;
    fi
    /home/pi/scripts/net-config.sh stop
fi
