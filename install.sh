#!/usr/bin/env bash

set -euo pipefail

# Install the bootloader theme
sudo cp -r ~/.config/dotfiles_hyprland/rose-pine /boot/EFI/refind/

# Scripts
mkdir -p ~/.local/bin && ln -sfn ~/.config/dotfiles_hyprland/scripts/* ~/.local/bin

# Hyprland
ln -sfn ~/.config/dotfiles_hyprland/hypr ~/.config/hypr

# Notification deamon
ln -sfn ~/.config/dotfiles_hyprland/dunst ~/.config/dunst
# ln -sfn ~/.config/dotfiles_hyprland/mako ~/.config/mako

# Top bar
ln -sfn ~/.config/dotfiles_hyprland/waybar ~/.config/waybar

# Launcher
ln -sfn ~/.config/dotfiles_hyprland/wofi ~/.config/wofi

# Break reminder
ln -sfn ~/.config/dotfiles_hyprland/hypr-breaktimer ~/.config/hypr-breaktimer
