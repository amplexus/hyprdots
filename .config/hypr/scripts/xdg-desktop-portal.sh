#!/usr/bin/env bash

# Per https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/
sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall -e xdg-desktop-portal-gnome
killall -e xdg-desktop-portal-kde
killall -e xdg-desktop-portal-lxqt
killall -e xdg-desktop-portal-wlr
killall -e xdg-desktop-portal-gtk
killall -e xdg-desktop-portal

/usr/local/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/libexec/xdg-desktop-portal &
