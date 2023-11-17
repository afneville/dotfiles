#!/bin/sh

while true; do

    inotifywait -e close_write $1 && \
        $2
done
