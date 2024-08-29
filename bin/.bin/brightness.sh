#!/bin/sh

increase_monitor_brightness() {
    # ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 2 setvcp 10 + 10 && ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 1 setvcp 10 + 10
    brightnessctl set +5%
}

decrease_monitor_brightness() {
    # ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 2 setvcp 10 - 10 && ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 1 setvcp 10 - 10
    brightnessctl set 5%-
}

set_monitor_brightness() {
    ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 2 setvcp 10 "$1" && ddcutil --sleep-multiplier 2.0 --maxtries "15,15,15" -d 1 setvcp 10 "$1"
}

if [ "$1" = "+" ]; then
    increase_monitor_brightness
elif [ "$1" = "-" ]; then
    decrease_monitor_brightness
elif [ "$1" = "high" ]; then
    set_monitor_brightness "80"
elif [ "$1" = "low" ]; then
    set_monitor_brightness "40"
fi
