#!/bin/bash

swaymsg output eDP-1 disable

echo "set \$left-display DP-2" > /home/alex/.config/sway/monitor-variables
echo "set \$right-display DP-2" >> /home/alex/.config/sway/monitor-variables
