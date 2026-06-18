#!/usr/bin/env bash

while true; do
    PROFILE=$(powerprofilesctl get)

    echo "Current profile: $PROFILE"

    if [ "$PROFILE" = "power-saver" ]; then
        echo "Switching to 60Hz"
        niri msg output eDP-1 mode 2560x1600@60.000
    elif [ "$PROFILE" = "performance" ]; then
        echo "Switching to 240Hz"
        niri msg output eDP-1 mode 2560x1600@240.002
    fi

    sleep 5
done