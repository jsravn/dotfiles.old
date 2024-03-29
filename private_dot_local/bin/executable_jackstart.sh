#!/usr/bin/env bash

# Pre-reqs:
# pacman -S jack2 pulseaudio-jack qjackctl non-session-manager
#
# Then invoke with ./jackstart.sh <card>
# Then start up non-session-manager
#
# Find card with cat /proc/asound/cards

set -eu

# stop jack if running
jack_control stop
# start up jack
jack_control ds alsa
jack_control dps device hw:$1
# gives 10ms latency - (147/44100)*3
jack_control dps rate 48000
jack_control dps nperiods 3
jack_control dps period 256
jack_control start
