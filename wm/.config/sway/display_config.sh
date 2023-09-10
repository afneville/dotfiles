#!/bin/bash

if [[ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]]; then
    swaymsg output eDP-1 disable
    swaymsg output DP-2 scale 2 transform 90 anticlockwise position 0 0
    swaymsg output HDMI-A-1 scale 2 position 1080 480
    swaymsg workspace 1
else
    swaymsg output eDP-1 enable
fi
