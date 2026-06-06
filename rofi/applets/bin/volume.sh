#!/usr/bin/env bash

# ==============================
# Theme Import
# ==============================
source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# ==============================
# Audio Info
# ==============================
mixer=$(amixer info Master | awk -F"'" '/Mixer name/ {print $2}')

speaker=$(amixer get Master | awk -F"[][]" 'END{print $2}')
mic=$(amixer get Capture | awk -F"[][]" 'END{print $2}')

# ==============================
# State detection
# ==============================
amixer get Master | grep -q '\[on\]'
if [[ $? -eq 0 ]]; then
    sicon="󰕾"
    stext="ON"
    active="-a 1"
else
    sicon="󰖁"
    stext="MUTED"
    urgent="-u 1"
fi

amixer get Capture | grep -q '\[on\]'
if [[ $? -eq 0 ]]; then
    micon="󰍬"
    mtext="ON"
else
    micon="󰍭"
    mtext="MUTED"
fi

# ==============================
# UI TEXT (LANDSCAPE STYLE)
# ==============================
prompt="Audio"
mesg="$mixer  |   $speaker  |   $mic"

# ==============================
# LANDSCAPE MODE
# ==============================
list_col=5
list_row=1
win_width="750px"

# ==============================
# ICON MODE
# ==============================
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
    option_1="󰕾 +"
    option_2="$sicon Toggle"
    option_3="󰕿 -"
    option_4="$micon Mic"
    option_5="󰍝 Settings"
else
    option_1="󰕾"
    option_2="󰖁"
    option_3="󰕿"
    option_4="󰍬"
    option_5="⚙"
fi

# ==============================
# WALLPAPER BACKGROUND (ADDED FIX 🔥)
# ==============================
WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

if [[ -z "$WALL" ]]; then
    WALL=$(ls -t ~/.config/hypr/img 2>/dev/null | head -n1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

# ==============================
# ROFI UI (WITH BACKGROUND FIX)
# ==============================
rofi_cmd() {
    rofi \
        -theme-str "window {
            width: $win_width;
            background-image: url('$WALL');
        }" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
        -markup-rows \
        -theme "$theme"
}

run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s" \
    "$option_1" "$option_2" "$option_3" "$option_4" "$option_5" \
    | rofi_cmd
}

# ==============================
# COMMANDS (UNCHANGED)
# ==============================
run_cmd() {
    case "$1" in
        --opt1)
            amixer -Mq set Master 5%+
            ;;
        --opt2)
            amixer set Master toggle
            ;;
        --opt3)
            amixer -Mq set Master 5%-
            ;;
        --opt4)
            amixer set Capture toggle
            ;;
        --opt5)
            command -v pavucontrol >/dev/null && pavucontrol &
            ;;
    esac
}

# ==============================
# EXECUTE
# ==============================
chosen="$(run_rofi)"

case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    $option_5) run_cmd --opt5 ;;
    *) exit 0 ;;
esac
