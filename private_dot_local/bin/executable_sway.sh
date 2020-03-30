#!/bin/sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh 2>/dev/null)
export SSH_AUTH_SOCK
export _JAVA_AWT_WM_NONREPARENTING=1
exec sway >~/.sway.out 2>~/.sway.err