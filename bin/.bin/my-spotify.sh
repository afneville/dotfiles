#!/bin/bash -m
spotify &
sleep 0.25
rmdir "$HOME/Downloads"
fg
