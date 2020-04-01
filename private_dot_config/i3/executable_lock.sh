#!/bin/sh -e

scrot -o ~/.cache/screen_locked.png
mogrify -scale 5% -scale 2000% ~/.cache/screen_locked.png
i3lock -i ~/.cache/screen_locked.png
sleep 60; pgrep i3lock && xset dpms force off
