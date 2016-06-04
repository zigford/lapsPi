#!/bin/bash

if ifconfig wlan0 &>/dev/null; then
    jessepi=10.1.1.3
else
    jessepi=zigford.ddns.net
fi

/home/pi/lapsPi/scripts/net-config.sh start
if [ $? == 0 ] ; then
    #rsync -avz -e ssh pi@${jessepi}:/home/pi/scripts /home/pi/
    cd ~/lapsPi
    git pull
fi
/home/pi/lapsPi/scripts/net-config.sh stop
crontab /home/pi/lapsPi/scripts/crontab
sudo cp -f /home/pi/lapsPi/scripts/superscript /etc/init.d/superscript

