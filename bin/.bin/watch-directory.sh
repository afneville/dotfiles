#!/bin/sh

while true; do

    inotifywait -e modify,create,delete -r $1 && \
        $2
done
