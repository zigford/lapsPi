#!/bin/bash

/usr/bin/pgrep -f timelapse.py || /usr/bin/nohup /usr/bin/python /home/pi/lapsPi/scripts/timelapse.py -W 1944 -H 1458 -n 1 >> /home/pi/timelapse.log &
