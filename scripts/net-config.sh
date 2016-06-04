#!/bin/bash

NetworkPowerOn () {

    #Power on SOC USB
    sudo sh -c 'echo 0x1 > /sys/devices/platform/soc/20980000.usb/buspower'
    #   Power on Relay
    sudo /usr/bin/usb-hub on
    #Start network stack
    sudo service networking start
    sleep 1m
    #Start 3g connection
    sudo wvdial telstra3g &
}

NetworkPowerOff () {
    #Could not start internet. Save power.
    sudo killall wvdial
    sudo service networking stop
    sudo sh -c 'echo 0x0 > /sys/devices/platform/soc/20980000.usb/buspower'
    sudo /usr/bin/usb-hub off
    echo stop net
}

NetworkTest () {
    ((count = 100))                        # Maximum number to try.
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
        return 0
    else
        return 1
    fi
}

if ifconfig wlan0; then
    echo "Running on wifi"
    exit 0
fi

if [ "$1" = "start" ] ; then
    NetworkPowerOn
    NetworkTest
elif [ "$1" = "stop" ] ; then
    NetworkPowerOff
elif [ "$1" = "test" ] ; then
    NetworkTest
else 
   echo "Usage: net-config.sh { start | stop | test }"
fi
