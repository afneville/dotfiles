#!/bin/sh

$@ &
pid=$!
while [ -z "$cid" ]; do
    cid=$(swaymsg -t get_tree | jq ".. | objects | select(.pid==$pid) | .id")
done
swaymsg "[con_id=$cid] floating enable"
swaymsg "[con_id=$cid] resize set 90 ppt 90 ppt"
swaymsg "[con_id=$cid] move position center"
