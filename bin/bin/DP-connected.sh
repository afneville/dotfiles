#!/bin/sh

[ -n "$(swaymsg -t get_outputs | grep DP-2)" ] && exit 0
