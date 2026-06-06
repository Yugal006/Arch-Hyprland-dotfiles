#!/usr/bin/env bash

WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

# fallback only if empty
if [ -z "$WALL" ]; then
    WALL=$(ls -t ~/.config/hypr/img | head -n 1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

rofi -show drun \
  -theme-str "
  imagebox {
      background-image: url(\"$WALL\", height);
  }
  " \
  -theme ~/.config/rofi/launchers/type-6/style-9.rasi
