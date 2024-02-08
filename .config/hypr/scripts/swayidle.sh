#!/usr/bin/env bash

pid=$(pgrep swayidle)
if [[ $? -eq 0 ]]; then
	echo "swayidle $pid is running"
	pkill swayidle
else
	echo "swayidle is NOT running"
	swayidle -w timeout 300 'swaylock -f' timeout 3600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
fi
