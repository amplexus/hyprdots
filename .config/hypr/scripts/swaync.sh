#!/usr/bin/env bash

pid=$(pgrep swaync)
if [[ $? -eq 0 ]]; then
	pkill swaync
fi
swaync -c ~/.config/swaync/config.json -s ~/.config/swaync/style.css
