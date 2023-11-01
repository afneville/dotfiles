#!/bin/sh

increase_monitor_brightness() {
    ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 2 setvcp 10 + 10 && ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 1 setvcp 10 + 10
}

decrease_monitor_brightness() {
    ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 2 setvcp 10 - 10 && ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 1 setvcp 10 - 10
}

set_monitor_brightness() {
    ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 2 setvcp 10 "$1" && ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 1 setvcp 10 "$1"
}

if [ "$1" = "+" ]; then
    if [ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]; then
        increase_monitor_brightness
    else
        brightnessctl set 10%+
    fi
elif [ "$1" = "-" ]; then
    if [ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]; then
        decrease_monitor_brightness
    else
        brightnessctl set 10%-
    fi
elif [ "$1" = "high" ]; then
    if [ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]; then
        set_monitor_brightness "80"
    else
        brightnessctl set 80%
    fi
elif [ "$1" = "low" ]; then
    if [ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ]; then
        set_monitor_brightness "40"
    else
        brightnessctl set 40%
    fi
fi
