#!/bin/sh

running="$(ps aux | grep swayidle | wc -l)"
[ "$running" = "1" ] || swayidle -w timeout 300 'before-sleep.sh' timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' before-sleep 'before-sleep.sh' &
