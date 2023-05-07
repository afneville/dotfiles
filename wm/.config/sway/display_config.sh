#!/bin/bash

if [[ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]]; then
    swaymsg output eDP-1 disable
    swaymsg workspace 1
else
    swaymsg output eDP-1 enable
fi
