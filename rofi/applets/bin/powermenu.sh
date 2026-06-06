#!/usr/bin/env bash

source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# -----------------------
# SYSTEM INFO
# -----------------------
prompt="$(whoami)"
mesg="Uptime: $(uptime -p | sed 's/up //g')"

# Layout fix (always landscape)
list_col=3
list_row=2
win_width="700px"

# -----------------------
# ICON MODE
# -----------------------
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
    option_1="Lock"
    option_2="Logout"
    option_3="Suspend"
    option_4="Hibernate"
    option_5="Reboot"
    option_6="Shutdown"

    yes="Yes"
    no="No"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
    option_5=""
    option_6=""

    yes=""
    no=""
fi

# -----------------------
# WALLPAPER FIX (IMPORTANT)
# -----------------------
WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

if [[ -z "$WALL" ]]; then
    WALL=$(ls -t ~/.config/hypr/img 2>/dev/null | head -n1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

# -----------------------
# ROFI UI
# -----------------------
rofi_cmd() {
    rofi \
        -theme-str "window {
            width: $win_width;
            background-image: url('$WALL');
        }" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$theme"
}

run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s\n%s" \
        "$option_1" "$option_2" "$option_3" \
        "$option_4" "$option_5" "$option_6" |
        rofi_cmd
}

# -----------------------
# SAFE CONFIRMATION
# -----------------------
confirm_cmd() {
    echo -e "$yes\n$no" | rofi -dmenu \
        -p "Confirm?" \
        -theme-str 'window {width: 300px;}' \
        -theme "$theme"
}

confirm_run() {
    selected=$(confirm_cmd)
    [[ "$selected" != "$yes" ]] && exit
}

# -----------------------
# ACTIONS (FIXED & SAFE)
# -----------------------
run_cmd() {
    case "$1" in
        --opt1)
            hyprlock
            ;;

        --opt2)
            confirm_run
            # proper logout (Hyprland safe fallback)
            hyprctl dispatch exit || pkill -KILL -u "$USER"
            ;;

        --opt3)
            confirm_run
            systemctl suspend
            ;;

        --opt4)
            confirm_run
            systemctl hibernate
            ;;

        --opt5)
            confirm_run
            systemctl reboot
            ;;

        --opt6)
            confirm_run
            systemctl poweroff
            ;;
    esac
}

# -----------------------
# RUN
# -----------------------
chosen="$(run_rofi)"

case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    $option_5) run_cmd --opt5 ;;
    $option_6) run_cmd --opt6 ;;
esac
