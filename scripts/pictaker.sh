#!/bin/bash

/usr/bin/pgrep -f timelapse.py || /usr/bin/nohup /usr/bin/python /home/pi/scripts/timelapse.py -W 2592 -H 1944 -i 1200 >> /home/pi/timelapse.log &
