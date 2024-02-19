#!/bin/bash -m
spotify-launcher &
sleep 0.25
rmdir "$HOME/Downloads"
fg
