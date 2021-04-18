#!/bin/bash

file="/home/wes/bashplan/notifications/$(date +"%Y%m%d%H%M".txt)"

if [ -f ${file} ]
then
    zenity --info --no-wrap --display=:0 --title="All Day Events" --text="$(cat $file)"
fi
