#!/usr/bin/env bash

# ============================================================
#  Hyprland Cheat Sheet — transparent bg, matugen fg colors
#  Place at: ~/.config/hypr/cheatsheet.sh
#  chmod +x ~/.config/hypr/cheatsheet.sh
# ============================================================

COLORS_FILE="${HOME}/.config/hypr/colors.conf"

hex_to_ansi_fg() {
    local rgba="$1"
    local hex="${rgba:5:6}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b"
}

get_color() {
    grep -m1 "^\$$1 " "$COLORS_FILE" 2>/dev/null | awk '{print $3}'
}

C_PRIMARY=$(get_color   "primary");           C_PRIMARY="${C_PRIMARY:-rgba(ffb3afff)}"
C_SECONDARY=$(get_color "secondary");         C_SECONDARY="${C_SECONDARY:-rgba(e7bdbaff)}"
C_TERTIARY=$(get_color  "tertiary");          C_TERTIARY="${C_TERTIARY:-rgba(e3c28cff)}"
C_ON_BG=$(get_color     "on_background");     C_ON_BG="${C_ON_BG:-rgba(f0deddff)}"
C_MUTED=$(get_color     "on_surface_variant"); C_MUTED="${C_MUTED:-rgba(d7c1c0ff)}"
C_OUTLINE=$(get_color   "outline");           C_OUTLINE="${C_OUTLINE:-rgba(a08c8bff)}"
C_ERR=$(get_color       "error");             C_ERR="${C_ERR:-rgba(ffb4abff)}"
C_TERTIARY_C=$(get_color "tertiary_container"); C_TERTIARY_C="${C_TERTIARY_C:-rgba(594319ff)}"

R='\033[0m'
B='\033[1m'
DIM='\033[2m'

PRI=$(hex_to_ansi_fg "$C_PRIMARY")
SEC=$(hex_to_ansi_fg "$C_SECONDARY")
TER=$(hex_to_ansi_fg "$C_TERTIARY")
FG=$(hex_to_ansi_fg  "$C_ON_BG")
MUT=$(hex_to_ansi_fg "$C_MUTED")
OUT=$(hex_to_ansi_fg "$C_OUTLINE")
ERR=$(hex_to_ansi_fg "$C_ERR")
ACC=$(hex_to_ansi_fg "$C_TERTIARY_C")

W=76   # visible width

div() {
    printf "${OUT}${DIM}  %s${R}\n" "$(printf '─%.0s' $(seq 1 $((W-2))))"
}

blank() { echo ""; }

hdr() {
    local title="  ◈  $1  ◈"
    local tlen=${#title}
    local right=$(( W - tlen - 2 ))
    printf "${PRI}${B}%s%${right}s${R}\n" "$title" ""
}

# row KEY DESC [extra_color]
row() {
    local key="$1" desc="$2" ec="${3:-$FG}"
    local klen=${#key} dlen=${#desc}
    local gap=$(( W - klen - dlen - 4 ))
    [[ $gap -lt 1 ]] && gap=1
    printf "  ${TER}${B}%s${R}${MUT}%${gap}s${R}${ec}%s${R}\n" "$key" "" "$desc"
}

sub() {   # sub-row (indented, dimmer)
    local key="$1" desc="$2"
    local klen=${#key} dlen=${#desc}
    local gap=$(( W - klen - dlen - 6 ))
    [[ $gap -lt 1 ]] && gap=1
    printf "    ${SEC}%s${R}${OUT}%${gap}s${R}${MUT}%s${R}\n" "$key" "" "$desc"
}

# ── Banner ───────────────────────────────────────────────────
clear
blank
printf "${PRI}${B}"
cat << 'BANNER'
   ██████╗██╗  ██╗███████╗ █████╗ ████████╗    ███████╗██╗  ██╗███████╗███████╗████████╗
  ██╔════╝██║  ██║██╔════╝██╔══██╗╚══██╔══╝    ██╔════╝██║  ██║██╔════╝██╔════╝╚══██╔══╝
  ██║     ███████║█████╗  ███████║   ██║       ███████╗███████║█████╗  █████╗     ██║   
  ██║     ██╔══██║██╔══╝  ██╔══██║   ██║       ╚════██║██╔══██║██╔══╝  ██╔══╝     ██║   
  ╚██████╗██║  ██║███████╗██║  ██║   ██║       ███████║██║  ██║███████╗███████╗   ██║   
   ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   
BANNER
printf "${R}"
blank
printf "${SEC}${B}"
printf '%s\n' \
  '                    ╔════════════════════════════════════╗' \
  '                    ║   Hyprland Keybinding  Cheat Sheet ║' \
  '                    ╚════════════════════════════════════╝'
printf "${R}"
blank
div

# ─────────────────────────────────────────────────────────────
# 1. WINDOW MANAGEMENT
# ─────────────────────────────────────────────────────────────
blank
hdr "WINDOW MANAGEMENT"
blank
row "SUPER + Enter / Return"    "Open terminal (kitty)"
row "SUPER + C"                 "Kill / close active window"
row "SUPER + V"                 "Toggle floating mode"
row "SUPER + P"                 "Pseudo tile  (dwindle layout)"
row "SUPER + J"                 "Toggle dwindle split direction"
row "SUPER + M"                 "Exit Hyprland (or hyprshutdown)"
blank
div

# ─────────────────────────────────────────────────────────────
# 2. FOCUS & MOVEMENT
# ─────────────────────────────────────────────────────────────
blank
hdr "FOCUS & MOVEMENT"
blank
row "SUPER + ←"                 "Move focus left"
row "SUPER + →"                 "Move focus right"
row "SUPER + ↑"                 "Move focus up"
row "SUPER + ↓"                 "Move focus down"
row "SUPER + LMB  (drag)"       "Move floating window"
row "SUPER + RMB  (drag)"       "Resize window"
blank
div

# ─────────────────────────────────────────────────────────────
# 3. WORKSPACES
# ─────────────────────────────────────────────────────────────
blank
hdr "WORKSPACES"
blank
row "SUPER + 1 … 9"             "Switch to workspace 1–9"
row "SUPER + 0"                 "Switch to workspace 10"
row "SUPER + SHIFT + 1 … 9"    "Move active window → workspace 1–9"
row "SUPER + SHIFT + 0"        "Move active window → workspace 10"
row "SUPER + Scroll ↓"         "Next workspace"
row "SUPER + Scroll ↑"         "Previous workspace"
blank
div

# ─────────────────────────────────────────────────────────────
# 4. APPS & LAUNCHERS
# ─────────────────────────────────────────────────────────────
blank
hdr "APPS & LAUNCHERS"
blank
row "SUPER + R"                 "Rofi application launcher"
row "SUPER + E"                 "File manager"
row "SUPER + A"                 "Rofi apps applet"
row "SUPER + Q"                 "Reload / relaunch Waybar"
blank
div

# ─────────────────────────────────────────────────────────────
# 5. ROFI APPLETS
# ─────────────────────────────────────────────────────────────
blank
hdr "ROFI APPLETS"
blank
row "SUPER + B"                 "Brightness control"
row "SUPER + SHIFT + B"         "Battery status"
row "SUPER + SHIFT + V"         "Volume control"
row "SUPER + X"                 "Power menu"
row "SUPER + SHIFT + S"         "Screenshot applet"
row "SUPER + CapsLock"          "Quick links"
row "SUPER + Y"                 "Clipboard history  (cliphist)"
blank
div

# ─────────────────────────────────────────────────────────────
# 6. SCREENSHOT
# ─────────────────────────────────────────────────────────────
blank
hdr "SCREENSHOT"
blank
row "Print"                     "Area screenshot  →  ~/Pictures/Screenshots/"
row "XF86SelectiveScreenshot"   "Area screenshot  (dedicated laptop key)"
blank
printf "  ${MUT}Saved as: ${OUT}screenshot-\$(date +%%s).png${R}\n"
blank
div

# ─────────────────────────────────────────────────────────────
# 7. LOCK SCREEN
# ─────────────────────────────────────────────────────────────
blank
hdr "LOCK SCREEN"
blank
row "SUPER + L"                 "Lock screen  (hyprlock)"
blank
div

# ─────────────────────────────────────────────────────────────
# 8. MEDIA CONTROLS  (playerctl)
# ─────────────────────────────────────────────────────────────
blank
hdr "MEDIA CONTROLS"
blank
row "XF86AudioPlay"             "Play"
row "XF86AudioPause"            "Pause"
row "XF86AudioNext"             "Next track"
row "XF86AudioPrev"             "Previous track"
blank
div

# ─────────────────────────────────────────────────────────────
# 9. AUDIO
# ─────────────────────────────────────────────────────────────
blank
hdr "AUDIO  (wpctl)"
blank
row "XF86AudioRaiseVolume"      "Volume  +5%  (capped at 100%)"
row "XF86AudioLowerVolume"      "Volume  −5%"
row "XF86AudioMute"             "Mute / unmute speaker"
row "XF86AudioMicMute"          "Mute / unmute microphone"
blank
div

# ─────────────────────────────────────────────────────────────
# 10. BRIGHTNESS  (brightnessctl)
# ─────────────────────────────────────────────────────────────
blank
hdr "BRIGHTNESS"
blank
row "XF86MonBrightnessUp"       "Brightness  +5%"
row "XF86MonBrightnessDown"     "Brightness  −5%"
blank
div

# ─────────────────────────────────────────────────────────────
# 11. WINDOW RULES  (active)
# ─────────────────────────────────────────────────────────────
blank
hdr "WINDOW RULES  (passive)"
blank
sub "suppress-maximize-events"  "All windows: suppress maximize requests"
sub "fix-xwayland-drags"        "XWayland floats: no_focus to fix dragging"
sub "move-hyprland-run"         "hyprland-run: float, bottom-left corner"
blank
div

# ── Footer ───────────────────────────────────────────────────
blank
printf "  ${MUT}◆ SUPER = Windows / Meta key\n"
printf "  ◆ Colors sourced live from: ${OUT}~/.config/hypr/colors.conf${MUT}  (matugen)${R}\n"
blank
div
blank
printf "  ${OUT}Press ${PRI}q${OUT} or ${PRI}Enter${OUT} to close…${R}  "
read -r -n1 key
[[ "$key" == "q" || "$key" == "" ]] && exit 0
