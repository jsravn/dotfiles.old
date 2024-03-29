#!/bin/sh

set -e

# fix java apps
export _JAVA_AWT_WM_NONREPARENTING=1
# for xdpw
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
# for sway to force correct device
export WLR_DRM_DEVICES=/dev/dri/card0

# Start up gnome-keyring to provide SSH key caching, etc.
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Start sway.
exec /usr/bin/sway --unsupported-gpu >~/.cache/sway-out.txt 2>~/.cache/sway-err.txt
