#!/bin/bash

swaymsg output eDP-1 disable
swaymsg output DP-2 transform 90 anticlockwise position 0 0
swaymsg output HDMI-A-1 position 2160 840
