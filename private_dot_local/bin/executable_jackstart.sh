#!/usr/bin/env bash

# pacman -S jack2 pulseaudio-jack qjackctl non-session-manager
# start up jack
jack_control ds alsa
jack_control dps device hw:$1
jack_control dps rate 44100
jack_control dps nperiods 3
jack_control dps period 64
jack_control start