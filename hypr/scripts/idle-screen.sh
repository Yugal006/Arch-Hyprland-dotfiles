#!/bin/bash

grim /tmp/idle.png
magick /tmp/idle.png \
    -blur 0x30 \
    -modulate 90,60 \
    /tmp/idle-blur.png
qs -p ~/.config/quickshell
