#!/bin/sh

[ "$1" = "headphones" ] && wpctl set-default "$(wpctl status | grep "Tiger Lake-LP Smart Sound Technology Audio Controller Speaker + Headphones" | cut -d. -f1 | awk '{print $NF}')"
[ "$1" = "1" ] && wpctl set-default "$(wpctl status | grep "Tiger Lake-LP Smart Sound Technology Audio Controller HDMI / DisplayPort 1 Output" | cut -d. -f1 | awk '{print $NF}')"
[ "$1" = "2" ] && wpctl set-default "$(wpctl status | grep "Tiger Lake-LP Smart Sound Technology Audio Controller HDMI / DisplayPort 2 Output" | cut -d. -f1 | awk '{print $NF}')"
[ "$1" = "3" ] && wpctl set-default "$(wpctl status | grep "Tiger Lake-LP Smart Sound Technology Audio Controller HDMI / DisplayPort 3 Output" | cut -d. -f1 | awk '{print $NF}')"
