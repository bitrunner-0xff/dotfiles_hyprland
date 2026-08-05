#!/usr/bin/env bash

set -euo pipefail

HYPRLAND_TYPE="desktop"
BOOTLOADER="refind"
DOTFILES_DIR="$HOME/.config/dotfiles_hyprland"

usage() {
    cat <<EOF
        Usage: $(basename "$0") -c <desktop|laptop> -b <grub|refind>

        Options:
            -c  Hyprland configuration profile
            -b  Bootloader whose theme should be installed
            -h  Show this help

        Examples:
            $(basename "$0") -c desktop -b refind
            $(basename "$0") -c laptop  -b grub
EOF
}

# Parse command line arguments
while getopts "c:b:h" opt; do
    case $opt in
    c)
        if [[ "$OPTARG" == "desktop" || "$OPTARG" == "laptop" ]]; then
            HYPRLAND_TYPE="$OPTARG"
        else
            echo "Error: -c must be 'desktop' or 'laptop'"
            exit 1
        fi
        ;;
    b)
        if [[ "$OPTARG" == "grub" || "$OPTARG" == "refind" ]]; then
            BOOTLOADER="$OPTARG"
        else
            echo "Error: -b must be 'grub' or 'refind'"
            exit 1
        fi
        ;;
    h)
        usage
        exit 0
        ;;
    *)
        echo "Invalid option."
        usage
        exit 1
        ;;
    esac
done

# BOOTLOADER THEME
BOOTLOADER_DIR="$DOTFILES_DIR/bootloader_theme"
if [[ "$BOOTLOADER" == "refind" ]]; then
    echo "Installing rEFInd theme..."
    sudo cp -r "$BOOTLOADER_DIR/refind/rose-pine" /boot/EFI/refind/
elif [[ "$BOOTLOADER" == "grub" ]]; then
    echo "Installing GRUB theme..."
    # Add GRUB theme installation here if you have one
    # sudo cp -r "$DOTFILES_DIR/grub-theme" /boot/grub/themes/
    # sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# SCIPTS
echo "Installing scripts..."
mkdir -p "$HOME/.local/bin"
ln -sfn "$DOTFILES_DIR/scripts/"* "$HOME/.local/bin"

# HYPRLAND
echo "Configuring Hyprland for $HYPRLAND_TYPE mode..."

echo "Creating symlinks for UWSM"
ln -sfn "$DOTFILES_DIR/uwsm/env" "$HOME/.config/uwsm/env"
ln -sfn "$DOTFILES_DIR/uwsm/env-hyprland" "$HOME/.config/uwsm/env-hyprland"

# Update the main hyprland.lua file based on config type
HYPRLAND_CONFIG="$DOTFILES_DIR/hypr/hyprland.lua"

if [[ "$HYPRLAND_TYPE" == "desktop" ]]; then
    echo "Switching to Desktop mode (external monitor setup)..."

    sed -i 's/^--require("hypr_desktop")/require("hypr_desktop")/' "$HYPRLAND_CONFIG"
    sed -i 's/^require("hypr_laptop")/--require("hypr_laptop")/' "$HYPRLAND_CONFIG"
elif [[ "$HYPRLAND_TYPE" == "laptop" ]]; then
    echo "Switching to Laptop mode (single monitor setup)..."

    sed -i 's/^require("hypr_desktop")/--require("hypr_desktop")/' "$HYPRLAND_CONFIG"
    sed -i 's/^--require("hypr_laptop")/require("hypr_laptop")/' "$HYPRLAND_CONFIG"
fi

echo "Creating symlink for Hyprland config..."
ln -sfn "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"

# NOTIFICATIONS
echo "Installing notification config (Dunst)..."
ln -sfn "$DOTFILES_DIR/dunst" "$HOME/.config/dunst"
# ln -sfn "$DOTFILES_DIR/mako" ~/.config/mako

# TOP BAR
echo "Installing Waybar config..."
ln -sfn "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"

# APP LAUNCHER
echo "Installing Wofi config..."
ln -sfn "$DOTFILES_DIR/wofi" "$HOME/.config/wofi"

if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo "Reloading Hyprland configuration..."
    hyprctl reload
else
    echo "Hyprland session not detected; skipping configuration reload."
    echo "The new configuration will be loaded when Hyprland starts."
fi

echo "✅ Installation complete!"
