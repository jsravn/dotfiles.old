#!/bin/bash -e

Lock_command="$HOME/.config/i3/lock.sh"
Suspend_command="systemctl suspend"
Reboot_command="systemctl reboot"
Poweroff_command="systemctl poweroff"
Quit_command="i3-msg exit"

rofi_command="rofi -lines 5 -width 5 -hide-scrollbar"

options=$'Lock\nSuspend\nReboot\nPoweroff\nQuit'

eval \$"$(echo "$options" | $rofi_command -dmenu -p "")_command"
