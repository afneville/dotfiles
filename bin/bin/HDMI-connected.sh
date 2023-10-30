#!/bin/sh

[ -n "$(swaymsg -t get_outputs | grep HDMI-A-1)" ] && exit 0
