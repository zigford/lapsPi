#!/bin/bash

dateDir=$(date +%d%m%y)
picDir="/home/pi/pics/${dateDir}"
echo Testing ${picDir}
ls ${picDir}
if [[ $? -ne 0 ]]; then
    mkdir -p ${picDir} 
fi
picName="$(date +%H%M).jpg"
raspistill -o "${picDir}/${picName}" -t 1 -ex auto
