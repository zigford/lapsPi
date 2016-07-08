#!/bin/bash

NetworkPowerOn () {

    #Power on SOC USB
    sudo sh -c 'echo 0x1 > /sys/devices/platform/soc/20980000.usb/buspower'
    #   Power on Relay
    sudo /usr/bin/usb-hub on
    #Start network stack
#    sudo service networking start
    #Start 3g connection
    if /sbin/ifconfig wlan0; then
	echo connected via wifi
    else
        sleep 3m
        if /sbin/ifconfig wlan0; then
	    echo connected via wifi
	else
    	    sudo wvdial telstra3g &
	fi
    fi
}

NetworkPowerOff () {
    #Could not start internet. Save power.
    #Before network power off, lets check if Wifi is available and if so, assume mains power
    if /sbin/ifconfig wlan0 ; then
	echo connected via wifi
	exit 0
    fi	 
    sudo killall wvdial
#    sudo service networking stop
#    sudo sh -c 'echo 0x0 > /sys/devices/platform/soc/20980000.usb/buspower'
#    sudo /usr/bin/usb-hub off
    echo stop net
}

NetworkTest () {
    ((count = 10))                        # Maximum number to try.
    while [[ $count -ne 0 ]] ; do
        sleep 5s
        ping -c 1 8.8.8.8                    # Try once.
        rc=$?
        if [[ $rc -eq 0 ]] ; then
            ((count = 1))                      # If okay, flag to exit loop.
        fi
        ((count = count - 1))                # So we don't go forever.
    done

    if [[ $rc -eq 0 ]] ; then              # Make final determination.
        sudo ntpdate -s 0.au.pool.ntp.org
	cd ~/lapsPi
	git pull
	crontab /home/pi/lapsPi/scripts/crontab
	sudo cp -f /home/pi/lapsPi/scripts/superscript /etc/init.d/superscript
        return 0
    else
        return 1
    fi
}

if [ "$1" = "start" ] ; then
    NetworkPowerOn
    if NetworkTest; then
	echo Succesfully connected to the network
	exit 0
    else
	echo Failed to connect. Aborting...
	exit 1
    fi
elif [ "$1" = "stop" ] ; then
    NetworkPowerOff
elif [ "$1" = "test" ] ; then
    NetworkTest
else 
   echo "Usage: net-config.sh { start | stop | test }"
fi
