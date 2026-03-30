#!/usr/bin/env bash

set -euo pipefail

# Install the bootloader theme
# sudo cp -rT ~/.config/dotfiles_hyprland/rose-pine /boot/EFI/refind/

# Install Hyprland environment
mkdir -p ~/.local/bin && ln -sfn ~/.config/dotfiles_hyprland/scripts/* ~/.local/bin
ln -sfn ~/.config/dotfiles_hyprland/hypr ~/.config/hypr
# ln -sfn ~/.config/dotfiles_hyprland/mako ~/.config/mako
ln -sfn ~/.config/dotfiles_hyprland/dunst ~/.config/dunst
ln -sfn ~/.config/dotfiles_hyprland/waybar ~/.config/waybar
ln -sfn ~/.config/dotfiles_hyprland/wofi ~/.config/wofi

# Zsh
ln -sfn ~/.config/dotfiles_hyprland/.zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

ln -sfn ~/.config/dotfiles_hyprland/starship.toml ~/.config/starship.toml

source ~/.zshrc
