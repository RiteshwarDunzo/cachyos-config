#!/usr/bin/env sh
# Finds LED entries matching *:red or *::red under /sys/class/leds/,
# resolves their real path, and outputs "led_path|real_path" per line.
for d in /sys/class/leds/*:red /sys/class/leds/*::red; do
    [ -e "$d" ] && echo "$d|$(realpath "$d")"
done 2>/dev/null
exit 0
