#!/usr/bin/env bash

set -eu

# needs dsp setup - see https://www.reddit.com/r/headphones/comments/abi6gp/linux_system_wide_eq/
pacmd load-module module-ladspa-sink sink_name=dsp sink_master=$1 plugin=ladspa_dsp label=ladspa_dsp
