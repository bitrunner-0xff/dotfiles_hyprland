#!/usr/bin/env bash
# This script provisions the system.

set -euo pipefail

# Install the bootloader theme
# sudo cp -rT ~/.config/dotfiles/rose-pine /boot/EFI/refind/

# My configs and scripts
mkdir -p ~/.local/bin && ln -sfn ~/.config/dotfiles/scripts/* ~/.local/bin
ln -sfn ~/.config/dotfiles/hypr ~/.config/hypr
# ln -sfn ~/.config/dotfiles/mako ~/.config/mako
ln -sfn ~/.config/dotfiles/dunst ~/.config/dunst
ln -sfn ~/.config/dotfiles/waybar ~/.config/waybar
ln -sfn ~/.config/dotfiles/wofi ~/.config/wofi

# Zsh
ln -sfn ~/.config/dotfiles/.zshrc ~/.zshrc
git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

ln -sfn ~/.config/dotfiles/starship.toml ~/.config/starship.toml

source ~/.zshrc
