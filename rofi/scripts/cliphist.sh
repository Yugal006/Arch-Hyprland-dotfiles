#!/usr/bin/env bash

WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

# Fallback wallpaper
if [ -z "$WALL" ]; then
    WALL=$(find ~/.config/hypr/img -type f | head -n 1)
fi

selection=$(cliphist list | rofi \
    -dmenu \
    -i \
    -matching fuzzy \
    -p "󰅌 Clipboard" \
    -theme-str "
    window {
        width: 800px;
	height: 300px;
    }

    imagebox {
        background-image: url(\"$WALL\", height);
    }

    listview {
        lines: 12;
    }
    " \
    -theme ~/.config/rofi/launchers/type-6/style-9.rasi)

if [ -n "$selection" ]; then
    echo "$selection" | cliphist decode | wl-copy
    notify-send "Clipboard" "Copied selection"
fi
[ -n "$selection" ] && echo "$selection" | cliphist decode | wl-copy
