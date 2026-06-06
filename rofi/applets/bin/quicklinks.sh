#!/usr/bin/env bash

source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# -----------------------
# UI
# -----------------------
prompt="Quick Links"
mesg="Open websites quickly"

list_col=2
list_row=3
win_width="700px"

# -----------------------
# Detect browser (FIXED for Flatpak)
# -----------------------
if command -v google-chrome >/dev/null; then
    BROWSER_CMD="google-chrome"
elif command -v brave >/dev/null; then
    BROWSER_CMD="brave"
elif flatpak info com.google.Chrome >/dev/null 2>&1; then
    BROWSER_CMD="flatpak run com.google.Chrome"
elif flatpak info com.brave.Browser >/dev/null 2>&1; then
    BROWSER_CMD="flatpak run com.brave.Browser"
else
    BROWSER_CMD="xdg-open"
fi

mesg="Browser: $BROWSER_CMD"

# -----------------------
# Icons
# -----------------------
option_1="󰚩 GPT"
option_2=" Gmail"
option_3=" YouTube"
option_4=" GitHub"
option_5=" Reddit"
option_6=" LeetCode"

# -----------------------
# Wallpaper (optional like your other scripts)
# -----------------------
WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

if [[ -z "$WALL" ]]; then
    WALL=$(ls -t ~/.config/hypr/img 2>/dev/null | head -n1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

# -----------------------
# Rofi UI
# -----------------------
rofi_cmd() {
    rofi \
        -theme-str "window { width: $win_width; background-image: url('$WALL'); }" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
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
# OPEN LINKS (SAFE)
# -----------------------
open_link() {
    local url="$1"

    if [[ "$BROWSER_CMD" == xdg-open ]]; then
        xdg-open "$url"
    else
        $BROWSER_CMD "$url" >/dev/null 2>&1 &
    fi
}

# -----------------------
# ACTIONS
# -----------------------
run_cmd() {
    case "$1" in
        --opt1) open_link "https://chat.openai.com/" ;;
        --opt2) open_link "https://mail.google.com/" ;;
        --opt3) open_link "https://www.youtube.com/" ;;
        --opt4) open_link "https://github.com/" ;;
        --opt5) open_link "https://www.reddit.com/" ;;
        --opt6) open_link "https://leetcode.com/yugal006/" ;;
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
