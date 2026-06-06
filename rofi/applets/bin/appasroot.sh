#!/usr/bin/env bash

# Import Theme
source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# UI Text
prompt="Apps"
mesg="Smart launcher (root only where needed)"

# Layout
list_col=4
list_row=1
win_width="650px"

# Detect icon mode
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

# Icons + Labels
if [[ "$layout" == 'NO' ]]; then
    option_1="Terminal (root)"
    option_2="Files (root)"
    option_3="Nano"
    option_4="Neovim"
else
    option_1=""
    option_2=""
    option_3=""
    option_4=""
fi

# Rofi UI
rofi_cmd() {

    WALL=$(cat ~/.config/hypr/current_wallpaper 2>/dev/null)

    if [ -z "$WALL" ]; then
        WALL=$(ls -t ~/.config/hypr/img | head -n 1)
        WALL="$HOME/.config/hypr/img/$WALL"
    fi

    rofi \
        -theme-str "window { background-image: url('$WALL'); }" \
        -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "  ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$theme"
}
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Command Handler
run_cmd() {

    polkit_cmd="pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR PATH=$PATH"

    case "$1" in
        --opt1) # Terminal (root)
            command -v alacritty >/dev/null && $polkit_cmd alacritty || notify-send "Alacritty not installed"
            ;;

        --opt2) # File Manager (root)
            command -v thunar >/dev/null && $polkit_cmd dbus-run-session thunar || notify-send "Thunar not installed"
            ;;

        --opt3) # Nano (root editor)
            command -v nano >/dev/null && $polkit_cmd alacritty -e nano || notify-send "Nano not installed"
            ;;

        --opt4) # Neovim (user)
            command -v nvim >/dev/null && alacritty -e nvim || notify-send "Neovim not installed"
            ;;
    esac
}

# Execute
chosen="$(run_rofi)"

case "$chosen" in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
esac
