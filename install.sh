#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "=========================================="
echo "      CachyOS Config Installer"
echo "=========================================="
echo

mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

backup() {
    if [ -e "$HOME/.config/$1" ]; then
        echo "Backing up ~/.config/$1"
        mv "$HOME/.config/$1" "$BACKUP_DIR/"
    fi
}

install_config() {
    if [ -d "$REPO_DIR/$1" ]; then
        echo "Installing $1"
        cp -r "$REPO_DIR/$1" "$HOME/.config/"
    fi
}

echo "[1/5] Installing configuration files..."
echo

CONFIGS=(
    niri
    waybar
    kitty
    fastfetch
    cava
    btop
    nvim
)

for config in "${CONFIGS[@]}"; do
    backup "$config"
    install_config "$config"
done

echo
echo "[2/5] Installing scripts..."
echo

if [ -d "$REPO_DIR/scripts" ]; then
    mkdir -p "$HOME/.config/scripts"
    cp -r "$REPO_DIR/scripts/"* "$HOME/.config/scripts/" 2>/dev/null || true
    chmod +x "$HOME/.config/scripts/"*.sh 2>/dev/null || true
fi

echo
echo "[3/5] Installing wallpapers..."
echo

if [ -d "$REPO_DIR/wallpapers" ]; then
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp -r "$REPO_DIR/wallpapers/"* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
fi

echo
echo "[4/5] Installing fonts..."
echo

if [ -d "$REPO_DIR/fonts" ]; then
    mkdir -p "$HOME/.local/share/fonts"
    cp -r "$REPO_DIR/fonts/"* "$HOME/.local/share/fonts/" 2>/dev/null || true
    fc-cache -fv >/dev/null
fi

echo
echo "[5/5] System configuration notice"
echo

if [ -d "$REPO_DIR/sddm" ]; then
    echo "SDDM configs detected in ./sddm"
fi

if [ -d "$REPO_DIR/grub" ]; then
    echo "GRUB configs detected in ./grub"
fi

echo
echo "=========================================="
echo "Installation Complete"
echo "=========================================="
echo
echo "Backup location:"
echo "$BACKUP_DIR"
echo
echo "NOTE:"
echo "- SDDM configs are NOT automatically installed."
echo "- GRUB configs are NOT automatically installed."
echo "- Review them manually before applying."
echo
echo "This setup is intended for:"
echo "- ASUS ROG Zephyrus G16 GU605MI"
echo "- NVIDIA RTX 4070 Laptop GPU"
echo "- Intel Arc iGPU"
echo "- Niri + Noctalia"
echo "- Catppuccin theme"
echo
echo "You may need to:"
echo "- Restart Niri"
echo "- Log out and back in"
echo
echo "Done."
