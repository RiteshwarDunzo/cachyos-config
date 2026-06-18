#!/usr/bin/env bash

STATE=""

while true; do
    if niri msg outputs | grep -q '(DP-5)'; then
        if [ "$STATE" != "external" ]; then
            echo "DP-5 connected"
            niri msg output eDP-1 off
            STATE="external"
        fi
    else
        if [ "$STATE" != "internal" ]; then
            echo "DP-5 disconnected"
            niri msg output eDP-1 on
            STATE="internal"
        fi
    fi

    sleep 2
done