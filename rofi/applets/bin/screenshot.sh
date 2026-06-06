#!/usr/bin/env bash

# ==============================
# Theme Import
# ==============================
source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# ==============================
# UI
# ==============================
prompt=" Screenshot"
mesg="📂 $(xdg-user-dir PICTURES)/Screenshots"

list_col=4
list_row=1
win_width="750px"

# ==============================
# Icon mode
# ==============================
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
    option_1=" Desktop"
    option_2=" Area"
    option_3="󰄀 5s"
    option_4="󰄀 10s"
else
    option_1=""
    option_2=""
    option_3="󰄀 5s"
    option_4="󰄀 10s"
fi

# ==============================
# Paths
# ==============================
time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}.png"

mkdir -p "$dir"

# ==============================
# Wallpaper (NEW PART 🔥)
# ==============================
WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

if [ -z "$WALL" ]; then
    WALL=$(ls -t ~/.config/hypr/img 2>/dev/null | head -n 1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

# ==============================
# Notifications
# ==============================
notify() {
    notify-send -u low -t 1200 "$1"
}

notify_success() {
    notify-send -u normal -t 2000 " Screenshot Saved"
}

notify_fail() {
    notify-send -u critical -t 2000 " Screenshot Failed"
}

# ==============================
# Clipboard
# ==============================
copy_clipboard() {
    wl-copy < "$dir/$file"
}

# ==============================
# Countdown
# ==============================
countdown() {
    local sec=$1
    while [ "$sec" -gt 0 ]; do
        notify "Taking shot in $sec..."
        sleep 1
        sec=$((sec - 1))
    done
}

# ==============================
# Screenshot Functions
# ==============================
shot_desktop() {
    grim "$dir/$file"
    copy_clipboard
    finish
}

shot_area() {
    geom=$(slurp)
    [[ -z "$geom" ]] && exit 0
    grim -g "$geom" "$dir/$file"
    copy_clipboard
    finish
}

shot_5() {
    countdown 5
    sleep 0.3
    grim "$dir/$file"
    copy_clipboard
    finish
}

shot_10() {
    countdown 10
    sleep 0.3
    grim "$dir/$file"
    copy_clipboard
    finish
}

# ==============================
# Finish
# ==============================
finish() {
    if [[ -f "$dir/$file" ]]; then
        notify_success
        command -v imv >/dev/null && imv "$dir/$file" &
    else
        notify_fail
    fi
    exit 0
}

# ==============================
# Rofi UI (WITH BACKGROUND 🔥)
# ==============================
rofi_cmd() {
    rofi \
        -theme-str "window { background-image: url('$WALL'); }" \
        -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$theme"
}

run_rofi() {
    printf "%s\n%s\n%s\n%s" \
    "$option_1" "$option_2" "$option_3" "$option_4" \
    | rofi_cmd
}

# ==============================
# Router
# ==============================
run_cmd() {
    case "$1" in
        --opt1) shot_desktop ;;
        --opt2) shot_area ;;
        --opt3) shot_5 ;;
        --opt4) shot_10 ;;
    esac
}

# ==============================
# Execute
# ==============================
chosen="$(run_rofi)"

case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    *) exit 0 ;;
esac
