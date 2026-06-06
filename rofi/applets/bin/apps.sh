#!/usr/bin/env bash

# Theme
source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# UI
prompt="Apps"
mesg="Quick Launcher"

# Layout
list_col=1
list_row=5
win_width="650px"

# Wallpaper
WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

if [ -z "$WALL" ]; then
    WALL=$(ls -t ~/.config/hypr/img 2>/dev/null | head -n 1)
    WALL="$HOME/.config/hypr/img/$WALL"
fi

# ----------------------------
# APPS (YOUR NEW MAP)
# ----------------------------

chrome_cmd="google-chrome-stable"
file_cmd="dolphin"
music_cmd="brave https://open.spotify.com"
settings_cmd="systemsettings 2>/dev/null || xfce4-settings-manager"

# VS Code / fallback removed (not needed now)

# Icons
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
    option_1="Chrome Browser"
    option_2="Dolphin File Manager"
    option_3="Spotify (Brave)"
    option_4="Settings"
    option_5="Neovim"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
    option_5=""
fi

# ----------------------------
# UI (with background)
# ----------------------------
rofi_cmd() {
    rofi \
        -theme-str "window { width: $win_width; background-image: url('$WALL'); }" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "  ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$theme"
}

run_rofi() {
    printf "%s\n%s\n%s\n%s\n%s" \
        "$option_1" "$option_2" "$option_3" "$option_4" "$option_5" |
        rofi_cmd
}

# ----------------------------
# ACTIONS
# ----------------------------
run_cmd() {
    case "$1" in
--opt1)
    flatpak run com.google.Chrome --no-sandbox
    ;;

--opt2)
    dolphin ;;

--opt3)
    flatpak run com.brave.Browser --no-sandbox https://open.spotify.com
    ;;

--opt4)
    systemsettings 2>/dev/null || xfce4-settings-manager
    ;;

--opt5)
    alacritty -e nvim
    ;;
    esac
}

# Run
chosen="$(run_rofi)"

case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    $option_5) run_cmd --opt5 ;;
esac
