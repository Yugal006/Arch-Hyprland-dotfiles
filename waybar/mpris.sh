#!/bin/bash

max_len=20

# get active player
get_active() {
    players=$(playerctl -l 2>/dev/null)

    for p in $players; do
        status=$(playerctl -p "$p" status 2>/dev/null)

        if [ "$status" = "Playing" ]; then
            title=$(playerctl -p "$p" metadata title 2>/dev/null)

            if [[ "$p" == *"spotify"* ]]; then
                icon=""
            elif [[ "$p" == *"brave"* ]] || [[ "$p" == *"chromium"* ]]; then
                icon=""
            else
                icon=""
            fi

            echo "▶ $icon $title"
            return
        fi
    done

    for p in $players; do
        status=$(playerctl -p "$p" status 2>/dev/null)

        if [ "$status" = "Paused" ]; then
            title=$(playerctl -p "$p" metadata title 2>/dev/null)
            echo "⏸ $title"
            return
        fi
    done

    # 👇 fallback → system info
    user=$(whoami)
    os=$(grep "^PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"')

    echo " $user | $os"
}

text=$(get_active)

len=${#text}

# short text → no scroll
if [ $len -le $max_len ]; then
    echo "$text"
    exit 0
fi

# scrolling
offset=$(($(date +%s) % (len - max_len + 1)))
echo "${text:$offset:$max_len}"