#!/usr/bin/env bash

BAT_PATH="/sys/class/power_supply/BAT0"
AC_PATH="/sys/class/power_supply/AC"

BAT=$(cat "$BAT_PATH/capacity" 2>/dev/null)
STATUS=$(cat "$BAT_PATH/status" 2>/dev/null)

PROFILE=$(powerprofilesctl get 2>/dev/null)

# =========================
# BATTERY ICON
# =========================
if [[ $BAT -ge 80 ]]; then ICON="󰁹"
elif [[ $BAT -ge 60 ]]; then ICON="󰂀"
elif [[ $BAT -ge 40 ]]; then ICON="󰁾"
elif [[ $BAT -ge 20 ]]; then ICON="󰁻"
else ICON="󰁺"
fi

# charging override
if [[ "$STATUS" == "Charging" ]]; then
    ICON="󰂄"
fi

# =========================
# POWER PROFILE ICON
# =========================
case "$PROFILE" in
    performance) PICON="" ;;
    balanced) PICON="" ;;
    power-saver) PICON="" ;;
    *) PICON="" ;;
esac

# =========================
# CLICK ACTION (cycle modes)
# =========================
if [[ "$1" == "toggle" ]]; then
    case "$PROFILE" in
        performance) powerprofilesctl set power-saver ;;
        power-saver) powerprofilesctl set balanced ;;
        balanced) powerprofilesctl set performance ;;
    esac
    exit 0
fi

# =========================
# OUTPUT (ONE CAPSULE)
# =========================
echo "{\"text\":\"$ICON $BAT% | $PICON \"}"
