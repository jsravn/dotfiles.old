#!/bin/sh -e

grim ~/.cache/screen_locked.png
mogrify -scale 5% -scale 2000% ~/.cache/screen_locked.png
swaylock -f -i ~/.cache/screen_locked.png
