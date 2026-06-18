#!/usr/bin/env sh
# Directly writes RGB values to the DS4/DualSense LED sysfs brightness files.
# Usage: write_color.sh <red_path> <green_path> <blue_path> <r> <g> <b>
# Outputs "direct:ok" on success, "direct:fail" if files are not writable.
RED_PATH="$1"
GREEN_PATH="$2"
BLUE_PATH="$3"
R="$4"
G="$5"
B="$6"

RED_BRIGHT="${RED_PATH}/brightness"
GREEN_BRIGHT="${GREEN_PATH}/brightness"
BLUE_BRIGHT="${BLUE_PATH}/brightness"

if [ -w "$RED_BRIGHT" ]; then
    printf '%s' "$R" > "$RED_BRIGHT" &&
    printf '%s' "$G" > "$GREEN_BRIGHT" &&
    printf '%s' "$B" > "$BLUE_BRIGHT" &&
    echo "direct:ok"
else
    echo "direct:fail"
fi
