#!/bin/bash

kitty \
  --class cyberclock \
  --override background_opacity=0.70 \
  bash -c '
while true; do
    clear
    echo "╭──────── CLOCK ────────╮"
    echo
    figlet "$(date +%H:%M:%S)"
    echo
    echo "╰───────────────────────╯"
    sleep 1
done
'
