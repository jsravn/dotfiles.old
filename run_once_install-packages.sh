#!/bin/sh

set -eu

sudo pacman -Sy --noconfirm --needed \
    ripgrep \
    zsh \
    chromium \
    emacs \
    editorconfig-core-c \
    fd \
    fzf \
    pyenv
