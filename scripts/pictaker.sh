#!/bin/bash

/usr/bin/pgrep -f timelapse.py || /usr/bin/nohup /usr/bin/python /home/pi/lapsPi/scripts/timelapse.py -W 2592 -H 1944 -n 1 >> /home/pi/timelapse.log &
