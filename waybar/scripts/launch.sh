#!/bin/bash

killall waybar

while pgrep -x waybar >/dev/null; do
    sleep 0.1
done

waybar >/tmp/waybar-debug.log 2>&1 &
