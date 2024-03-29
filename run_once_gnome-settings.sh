#!/bin/sh

. /etc/os-release
if [ "$ID" != "arch" ]; then
    exit
fi

set -eu

if command -v gsettings >/dev/null; then
  # Disable keys which conflict with IntelliJ, Discord, etc.
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['']"
  # Speed up key rate.
  gsettings set org.gnome.desktop.peripherals.keyboard delay 225
  gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
fi
