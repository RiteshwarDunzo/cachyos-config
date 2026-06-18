# External Monitor Auto Switch

## Purpose

Automatically disable the laptop display (`eDP-1`) when the external monitor (`DP-5`) is connected and re-enable it when the monitor is disconnected.

This script is designed for my ASUS ROG Zephyrus G16 running CachyOS, Niri, and Wayland.

## Script Location

```text
~/.local/bin/external-monitor.sh
```

## Script

```bash
#!/usr/bin/env bash

STATE=""

while true; do
    if niri msg outputs | grep -q '(DP-5)'; then
        if [ "$STATE" != "external" ]; then
            niri msg output eDP-1 off
            STATE="external"
        fi
    else
        if [ "$STATE" != "internal" ]; then
            niri msg output eDP-1 on
            STATE="internal"
        fi
    fi

    sleep 2
done
```

## Autostart

Add to the Niri configuration:

```kdl
spawn-at-startup "bash" "-c" "~/.local/bin/external-monitor.sh"
```

## Behavior

* DP-5 connected → eDP-1 turns off.
* DP-5 disconnected → eDP-1 turns on.
* Starts automatically with Niri.
* No additional dependencies required.

## Hardware

Laptop Panel:

* eDP-1
* 2560x1600
* 240Hz

External Monitor:

* DP-5
* LG UltraGear 1440p 180Hz

```
```
