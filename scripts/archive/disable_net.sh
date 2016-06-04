#!/bin/bash

NetworkPowerOn () {

    #Power on SOC USB
    sudo sh -c 'echo 0x1 > /sys/devices/platform/soc/20980000.usb/buspower'
    #   Power on Relay
    sudo /usr/bin/usb-hub on
    sleep 5s
    #Start network stack
    sudo service networking start

    #Start 3g connection
    sudo wvdial telstra3g &
    sleep 20s
}

NetworkPowerOff () {
    #Could not start internet. Save power.
    sudo killall wvdial
    sudo service networking stop
    sudo sh -c 'echo 0x0 > /sys/devices/platform/soc/20980000.usb/buspower'
    sudo /usr/bin/usb-hub off
    echo stop net
}
if ifconfig wlan0; then
    /home/pi/scripts/uploader.sh
else 
    NetworkPowerOn

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
        #Internet Up, start tunnel
        #~/sshtunnel.sh&
        /home/pi/scripts/uploader.sh
        NetworkPowerOff
    else
        NetworkPowerOff
    fi
fi
