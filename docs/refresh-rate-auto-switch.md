# Automatic Refresh Rate Switching

## Purpose

Automatically switch the laptop display refresh rate based on the active power profile.

Designed for ASUS ROG Zephyrus G16 running CachyOS, Niri, and Wayland.

## Behavior

| Power Profile | Refresh Rate |
| ------------- | ------------ |
| power-saver   | 60 Hz        |
| performance   | 240 Hz       |

The script continuously monitors the current power profile using `powerprofilesctl` and applies the appropriate refresh rate to the laptop display.

## Script Location

```text
~/.local/bin/refresh-rate-auto.sh
```

## Script

```bash
#!/usr/bin/env bash

while true; do
    PROFILE=$(powerprofilesctl get)

    if [ "$PROFILE" = "power-saver" ]; then
        niri msg output eDP-1 mode 2560x1600@60.000
    elif [ "$PROFILE" = "performance" ]; then
        niri msg output eDP-1 mode 2560x1600@240.002
    fi

    sleep 5
done
```

## Autostart

Add to the Niri configuration:

```kdl
spawn-at-startup "/home/riteshwar/.local/bin/refresh-rate-auto.sh"
```

## Requirements

* Niri
* power-profiles-daemon
* powerprofilesctl

## Hardware

Laptop:

* ASUS ROG Zephyrus G16

Display:

* eDP-1
* Resolution: 2560x1600
* Refresh Rates:

  * 60 Hz
  * 240 Hz

## Notes

* The script consumes negligible system resources.
* Running at 60 Hz on battery helps reduce power consumption.
* Performance mode automatically restores the panel's full 240 Hz refresh rate.
* Changes are applied dynamically without requiring a logout or reboot.
* Refresh rate changes are temporary and managed through Niri IPC commands.

```
```
