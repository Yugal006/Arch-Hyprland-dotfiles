#!/usr/bin/env bash

# Import Theme
source "$HOME/.config/rofi/applets/shared/theme.bash"
theme="$type/$style"

# Battery Info
battery="$(acpi -b | cut -d',' -f1 | cut -d':' -f1)"
status="$(acpi -b | cut -d',' -f1 | cut -d':' -f2 | tr -d ' ')"
percentage="$(acpi -b | cut -d',' -f2 | tr -d ' ',\%)"
time="$(acpi -b | cut -d',' -f3)"

[ -z "$time" ] && time=" Fully Charged"

# UI Text
prompt="$status"
current_profile=$(powerprofilesctl get)
mesg="${battery}: ${percentage}% ${time} | Mode: $current_profile"

# Layout
list_col=4
list_row=1
win_width="550px"

# Charging Icon
active=""
urgent=""

if [[ $status == *"Charging"* ]]; then
	active="-a 1"
	ICON_CHRG=""
elif [[ $status == *"Full"* ]]; then
	active="-u 1"
	ICON_CHRG=""
else
	urgent="-u 1"
	ICON_CHRG=""
fi

# Battery Level Icon
if [[ $percentage -ge 80 ]]; then
	ICON_DISCHRG=""
elif [[ $percentage -ge 60 ]]; then
	ICON_DISCHRG=""
elif [[ $percentage -ge 40 ]]; then
	ICON_DISCHRG=""
elif [[ $percentage -ge 20 ]]; then
	ICON_DISCHRG=""
else
	ICON_DISCHRG=""
fi

# Options
layout=$(grep -o 'USE_ICON=.*' "$theme" | cut -d'=' -f2)

if [[ "$layout" == 'NO' ]]; then
	option_1="Battery ${percentage}%"
	option_2="$status"
	option_3="Power"
	option_4="Diag"
else
	option_1="$ICON_DISCHRG"
	option_2="$ICON_CHRG"
	option_3=""
	option_4=""
fi

# 🔥 SINGLE Rofi CMD (with wallpaper)
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
        -theme-str "textbox-prompt-colon {str: \"$ICON_DISCHRG\";}" \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        ${active} ${urgent} \
        -markup-rows \
        -theme "$theme"
}

# Run UI
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Actions
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		notify-send "Battery: ${percentage}%"

	elif [[ "$1" == '--opt2' ]]; then
		notify-send "Status: $status"

	elif [[ "$1" == '--opt3' ]]; then
		profile=$(printf "performance\nbalanced\npower-saver" | rofi -dmenu -p "Power Mode")

		case "$profile" in
			performance) powerprofilesctl set performance ;;
			balanced) powerprofilesctl set balanced ;;
			power-saver) powerprofilesctl set power-saver ;;
		esac

	elif [[ "$1" == '--opt4' ]]; then
		pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
		XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
		alacritty -e powertop
	fi
}

# Execute
chosen="$(run_rofi)"

case "$chosen" in
	$option_1) run_cmd --opt1 ;;
	$option_2) run_cmd --opt2 ;;
	$option_3) run_cmd --opt3 ;;
	$option_4) run_cmd --opt4 ;;
esac
