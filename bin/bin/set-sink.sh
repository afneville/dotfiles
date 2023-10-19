#!/bin/sh

[ "$1" = "headphones" ] && wpctl set-default "$(wpctl status | grep "Tiger Lake-LP Smart Sound Technology Audio Controller Speaker + Headphones" | cut -d. -f1 | awk '{print $NF}')"
[ "$1" = "monitor" ] && wpctl set-default "$(wpctl status | grep "Tiger Lake-LP Smart Sound Technology Audio Controller HDMI / DisplayPort 1 Output" | cut -d. -f1 | awk '{print $NF}')"
