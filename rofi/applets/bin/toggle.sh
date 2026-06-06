#!/bin/bash

APP="$1"
shift

# if rofi is running → close it
if pgrep -x rofi >/dev/null; then
    pkill rofi
    exit 0
fi

# otherwise run applet
bash "$APP" "$@"
