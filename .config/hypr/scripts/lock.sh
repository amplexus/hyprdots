#!/usr/bin/env bash

playstatus=$(playerctl status)
[ "$playstatus" == "Playing" ] && playerctl pause
swaylock -i "$(cat ~/.cache/current_wallpaper)"
