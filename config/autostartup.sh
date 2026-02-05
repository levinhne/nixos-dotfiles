#!/bin/bash

# ───────────────────────────────────────────────────────────────
# Wayland & XDG Setup
# ───────────────────────────────────────────────────────────────
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway &
/usr/lib/xdg-desktop-portal-wlr &
/usr/lib/xdg-desktop-portal -r &

# ───────────────────────────────────────────────────────────────
# Idle Configuration
# ───────────────────────────────────────────────────────────────
# Lock after 300s, turn off displays after 600s, lock before sleep
swayidle -w \
    timeout 300 'swaylock \
        --color 282a36 \
        --inside-color 44475a \
        --inside-clear-color 6272a4 \
        --inside-ver-color bd93f9 \
        --inside-wrong-color ff5555 \
        --ring-color 6272a4 \
        --ring-clear-color 8be9fd \
        --ring-ver-color bd93f9 \
        --ring-wrong-color ff5555 \
        --key-hl-color 50fa7b \
        --bs-hl-color ff79c6 \
        --separator-color 282a36 \
        --text-color f8f8f2 \
        --text-clear-color f8f8f2 \
        --text-ver-color f8f8f2 \
        --text-wrong-color f8f8f2 \
        --indicator-radius 100 \
        --indicator-thickness 10 \
        --font "Iosevka Nerd Font Mono"' \
    timeout 600 'swaymsg output "*" power off' \
    resume 'swaymsg output "*" power on' \
    before-sleep 'swaylock -f -c 282a36' &

# ───────────────────────────────────────────────────────────────
# Autostart Applications
# ───────────────────────────────────────────────────────────────

# Sway-specific tools
if [ "$XDG_CURRENT_DESKTOP" = "sway" ] || [ -n "$SWAYSOCK" ]; then
    # Sov - Workspace overview
    rm -f /tmp/sovpipe && mkfifo /tmp/sovpipe && tail -f /tmp/sovpipe | sov -t 500 &
    
    # Window management
    autotiling -l 2 &
fi

# Applications
fcitx5 -d &
mako &

# Clipboard management
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# UI components
~/.config/waybar/launch.sh &
nwg-wrapper -t sway.pango -p right -mr 10 &
nwg-wrapper -s quick.sh -a end -p left -ml 10 -mb 10 -r 60 &
nwg-wrapper -s quote.sh -p left -a end -mb 10 -ml 260 &

# Wallpaper
swww-daemon &
~/.local/bin/random-wallpaper.sh &
