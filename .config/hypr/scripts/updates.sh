#!/usr/bin/env bash
#	Script to check for new updates in ubuntu

get_total_updates() {
	local total_updates=$(apt list --upgradable 2>/dev/null | wc -l)
	let total_updates=$total_updates-1
	# echo "${total_updates:-0}"
	printf '{"text": "%s", "alt": "%s", "tooltip": "%s Updates", "class": "%s"}' "$total_updates" "$total_updates" "$total_updates" "green"
}

get_list_updates() {
	local total_updates=$(apt list --upgradable 2>/dev/null | wc -l)
	let total_updates=$total_updates-1
	echo -e "\033[1m\033[34mRegular updates:\033[0m"
	apt list --upgradable 2>/dev/null
}

print_updates() {
	local print_updates=$(apt list --upgradable 2>/dev/null | wc -l)
	let print_updates=$print_updates-1

	if [[ $print_updates -gt 0 ]]; then
		echo -e "\033[1m\033[33mThere are $print_updates updates available:\033[0m\n"
		get_list_updates
	else
		echo -e "\033[1m\033[32mYour system is already updated!\033[0m"
	fi
}

update_system() {
	sudo apt upgrade -y
	echo "Press enter to close this window"
	read dummy
}

case "$1" in
--get-updates) get_total_updates ;;
--print-updates) print_updates ;;
--update-system) update_system ;;
--help | *) echo -e "Updates [options]
  
Options:
	--get-updates		Get the number of updates available.
	--print-updates		Print the available package to updates.
	--update-system		Update your system.\n" ;;
esac
