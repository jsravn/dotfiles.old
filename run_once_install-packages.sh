#!/bin/sh

set -eu

sudo pacman -Sy --noconfirm --needed \
    ripgrep \
    zsh \
    chromium \
    editorconfig-core-c \
    fd \
    fzf \
    pyenv \
    zsh-autosuggestions \
    zsh-syntax-highlighting

if command -v yay > /dev/null; then
    yay -S zsh-theme-powerlevel10k-git
fi
