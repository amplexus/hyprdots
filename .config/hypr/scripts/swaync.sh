#!/usr/bin/env bash

exec 2>&1 >~/.config/hypr/swaync.log

pid=$(pgrep swaync)
if [[ $? -eq 0 ]]; then
	pkill swaync
fi
swaync -c ~/.config/swaync/config.json -s ~/.config/swaync/style.css
