#!/bin/bash

if ifconfig wlan0 &>/dev/null; then
    jessepi=10.1.1.250
else
    jessepi=zigford.ddns.net
fi

/home/pi/scripts/net-config.sh start
if [ $? == 0 ] ; then
    rsync -avz -e ssh pi@${jessepi}:/home/pi/scripts /home/pi/
fi
/home/pi/scripts/net-config.sh stop
crontab /home/pi/scripts/crontab
sudo cp -f /home/pi/scripts/superscript /etc/init.d/superscript

