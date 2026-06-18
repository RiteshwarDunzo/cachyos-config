#!/usr/bin/env bash

# ------------------------------
# DS4 Colors Udev Setup
# ------------------------------
# This script sets up udev rules to allow a non-root user to write to
# /sys/class/leds/*/brightness for DualShock 4 and DualSense controllers.
# It creates a group 'ds4_colors' and adds the target user to this group.
#
# Usage:
#  $ sudo ./setup_rules.sh        # uses SUDO_USER (with sudo)
#  $ ./setup_rules.sh username    # use provided username (if ran as root)
# ------------------------------
set -e

RULE_FILE="$(dirname "$0")/99-ds4-colors.rules"
GROUP_NAME="ds4_colors"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
	echo "Error: This script must be run as root (use sudo)"
	exit 1
fi

# Determine target user
TARGET_USER=${SUDO_USER:-$1}

if [ -z "$TARGET_USER" ]; then
	echo "Error: No target user specified." >&2
	exit 1
fi

if [ ! -f "$RULE_FILE" ]; then
	echo "Error: $RULE_FILE not found in current directory" >&2
	exit 1
fi

if ! getent group "$GROUP_NAME" >/dev/null; then
	echo "Creating $GROUP_NAME group..."
	groupadd "$GROUP_NAME"
fi

echo "Adding $TARGET_USER to $GROUP_NAME group..."
usermod -aG "$GROUP_NAME" "$TARGET_USER"

echo "Installing $RULE_FILE"
cp "$RULE_FILE" /etc/udev/rules.d/

echo "Reloading rules..."
udevadm control --reload-rules && udevadm trigger

echo "You may need a reboot for the plugin's write access to take effect"
echo "Done!"
