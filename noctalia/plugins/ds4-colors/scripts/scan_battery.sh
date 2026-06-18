#!/usr/bin/env sh
# Finds the battery capacity for a Sony/PlayStation controller.
# Matches by directory name, the optional "name" file, and the device symlink
# to support NixOS (no "name" file) and standard distros.
for bat in /sys/class/power_supply/*/capacity; do
    dir=$(dirname "$bat")
    base=$(basename "$dir")
    name=""
    [ -f "$dir/name" ] && name=$(cat "$dir/name" 2>/dev/null)
    devlink=""
    [ -L "$dir/device" ] && devlink=$(readlink "$dir/device" 2>/dev/null)
    case "$base$name$devlink" in
        *[Ss]ony*|*[Dd]ual[Ss]ense*|*[Dd]ual[Ss]hock*|*054[Cc]*|*ps-controller*)
            cat "$bat" 2>/dev/null
            exit 0;;
    esac
done
echo -1
