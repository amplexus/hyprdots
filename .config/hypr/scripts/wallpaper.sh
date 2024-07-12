#!/usr/bin/env bash

exec 2>&1 >~/.config/hypr/wallpaper.log

rasi_file=~/.cache/current_wallpaper.rasi

which wal || export PATH=~/.venv/bin:$PATH

case $1 in

"init")
	# Load wallpaper from .cache of last session
	echo "Initialising..."
	[ -f ~/.cache/current_wallpaper ] && wallpaper=$(cat ~/.cache/current_wallpaper)
	# If not found or empty, set randomly
	if [[ ! -f "$wallpaper" ]]; then
		echo "Current wallpaper not found, selecting one at random"
		wallpaper=$(find ~/.config/hypr/walls -type f | shuf -n 1)
		# Cache file for holding the current wallpaper
		echo "$wallpaper" >~/.cache/current_wallpaper
		echo "Selected $wallpaper"
	else
		echo "Found and using current wallpaper $wallpaper"
	fi
	# Tell wal to use the wallpaper
	echo "Don't run pywal at startup as it crashes hyprland"
	# wal -i "$wallpaper"
	echo "Running wpg init script"
	[ -f ~/.config/wpg/wp_init.sh ] && ~/.config/wpg/wp_init.sh
	;;

# Select wallpaper with rofi
"select")

	[ ! -f "$rasi_file" ] && echo "* { current-image: url(\"${wallpaper}\", height); }" >"$rasi_file"
	selected=$(find ~/.config/hypr/walls -type f -exec basename {} \; | sort -R | while read -r fname; do
		echo -en "$fname\x00icon\x1f$HOME/.config/hypr/walls/${fname}\n"
	done | rofi -dmenu -replace -config ~/.config/rofi/config-wallpaper.rasi)
	if [ ! "$selected" ]; then
		echo "CRJ::No wallpaper selected"
		exit
	fi
	wallpaper="$HOME/.config/hypr/walls/$selected"
	echo "CRJ::Newly selected wallpaper: $wallpaper"
	echo "$wallpaper" >~/.cache/current_wallpaper
	wal -i "$wallpaper"
	;;

# Randomly select wallpaper
*)
	[ -f ~/.cache/current_wallpaper ] && wallpaper=$(cat ~/.cache/current_wallpaper)
	echo "CRJ::Randomly selecting wallpaper to replace: $wallpaper"
	newwallpaper=""
	while true; do
		newwallpaper=$(find ~/.config/hypr/walls -type f | shuf -n 1)
		[ "$newwallpaper" != "$wallpaper" ] && break
	done
	echo "CRJ::Replacing $wallpaper with randomly selected wallpaper: $newwallpaper"
	wallpaper="$newwallpaper"
	echo "$wallpaper" >~/.cache/current_wallpaper
	wal -q -i "$wallpaper"
	;;

esac

# Load current pywal color scheme
[ -f ~/.cache/wal/colors.sh ] && source ~/.cache/wal/colors.sh

echo "CRJ::Chosen Wallpaper: $wallpaper"

# Write selected wallpaper into .cache files
echo "* { current-image: url(\"$wallpaper\", height); }" >"$rasi_file"

# Reload waybar with new colors
~/.config/hypr/scripts/waybar.sh

# Set the new wallpaper
transition_type="wipe" # or "outer" or "random"

swww img "$wallpaper" \
	--transition-bezier .43,1.19,1,.4 \
	--transition-fps=60 \
	--transition-type=$transition_type \
	--transition-duration=0.7 \
	--transition-pos "$(hyprctl cursorpos)"

# [ $(which wpg) ] && wpg -i default ~/.cache/wal/colors.json

# Reload swaync config
# swaync-client --reload-css

# GTK

which wpg && wpg -s $(cat ~/.cache/current_wallpaper)

# Send notification
sleep 1
notify-send "Colors and Wallpaper updated" "with image $wallpaper"

echo "DONE!"
