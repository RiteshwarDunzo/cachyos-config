#!/usr/bin/env bash
# DS4/DualSense LED Color Setter
# Usage: ./set_ds4_color.sh <base_path> <separator> <r> <g> <b>

set -e

BASE_PATH="$1"
SEP="$2"
R="$3"
G="$4"
B="$5"

if [ -z "$BASE_PATH" ] || [ -z "$SEP" ] || [ -z "$R" ] || [ -z "$G" ] || [ -z "$B" ]; then
    echo "Usage: $0 <base_path> <separator> <r> <g> <b>" >&2
    exit 1
fi

# Set individual color components
RED_PATH="${BASE_PATH}${SEP}red/brightness"
GREEN_PATH="${BASE_PATH}${SEP}green/brightness"
BLUE_PATH="${BASE_PATH}${SEP}blue/brightness"

# Check if paths exist
if [ ! -f "$RED_PATH" ] || [ ! -f "$GREEN_PATH" ] || [ ! -f "$BLUE_PATH" ]; then
    echo "LED brightness files not found" >&2
    exit 1
fi

# Write colors
echo "$R" > "$RED_PATH"
echo "$G" > "$GREEN_PATH"
echo "$B" > "$BLUE_PATH"

# Set global brightness to max if it exists
GLOBAL_PATH="${BASE_PATH}${SEP}global/brightness"
if [ -f "$GLOBAL_PATH" ]; then
    MAX=$(cat "${BASE_PATH}${SEP}global/max_brightness" 2>/dev/null || echo 255)
    echo "$MAX" > "$GLOBAL_PATH"
fi

exit 0
