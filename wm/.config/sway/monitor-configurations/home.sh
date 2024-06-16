#!/bin/bash

horiz="$(swaymsg --pretty -t get_outputs | grep ETN4P00759SL0 | cut -d' ' -f2)"
vert="$(swaymsg --pretty -t get_outputs | grep ETGAM01835SL0 | cut -d' ' -f2)"
swaymsg output eDP-1 disable
swaymsg output ${vert} transform 90 anticlockwise position 0 0
swaymsg output ${horiz} position 2160 960

echo "set \$left-display ${vert}" > /home/alex/.config/sway/monitor-variables
echo "set \$right-display ${horiz}" >> /home/alex/.config/sway/monitor-variables
