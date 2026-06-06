#!/usr/bin/env bash

source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# -----------------------
# Brightness Info (FIXED)
# -----------------------
backlight_raw=$(brightnessctl get 2>/dev/null)
backlight_max=$(brightnessctl max 2>/dev/null)

if [[ -n "$backlight_raw" && -n "$backlight_max" ]]; then
    backlight=$(( backlight_raw * 100 / backlight_max ))
else
    backlight=50
fi

card=$(brightnessctl info 2>/dev/null | head -n1 | cut -d':' -f1)

# Level
if (( backlight <= 29 )); then
    level="Low"
elif (( backlight <= 49 )); then
    level="Optimal"
elif (( backlight <= 69 )); then
    level="High"
else
    level="Peak"
fi

prompt="${backlight}%"
mesg="Device: ${card:-Unknown} | Level: $level"

# -----------------------
# LANDSCAPE MODE
# -----------------------
list_col=4
list_row=1
win_width="600px"

# -----------------------
# ICONS
# -----------------------
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
    option_1="Increase (+5%)"
    option_2="Set 50%"
    option_3="Decrease (-5%)"
    option_4="Settings"
else
    option_1="☀"
    option_2="🔆"
    option_3="🌙"
    option_4="⚙"
fi

# -----------------------
# WALLPAPER FIX
# -----------------------
WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

if [ -z "$WALL" ]; then
    WALL=$(ls -t ~/.config/hypr/img 2>/dev/null | head -n1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

# -----------------------
# ROFI UI
# -----------------------
rofi_cmd() {
    rofi \
        -theme-str "window { width: $win_width; background-image: url('$WALL'); }" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "☀";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$theme"
}

run_rofi() {
    printf "%s\n%s\n%s\n%s" \
        "$option_1" "$option_2" "$option_3" "$option_4" |
        rofi_cmd
}

# -----------------------
# ACTIONS
# -----------------------
run_cmd() {
    case "$1" in
        --opt1) brightnessctl set 5%+ ;;
        --opt2) brightnessctl set 50% ;;
        --opt3) brightnessctl set 5%- ;;
        --opt4) xfce4-power-manager-settings 2>/dev/null ;;
    esac
}

# -----------------------
# RUN MENU
# -----------------------
chosen="$(run_rofi)"

case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
esac
