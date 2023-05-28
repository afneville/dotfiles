#!/bin/bash

if [[ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]]; then
    swaymsg output eDP-1 disable
    swaymsg workspace 1
    if [[ -n "$(swaymsg -t get_outputs | grep 3840)" ]]; then
        swaymsg output HDMI-A-1 resolution 3840x2160 scale 2
    fi
else
    swaymsg output eDP-1 enable
fi
