#!/bin/bash

# Kill any running waybar instances
killall waybar 2>/dev/null

# Wait for processes to terminate
sleep 0.5

# Auto-detect compositor and launch appropriate config
if [ "$SWAYSOCK" ]; then
    echo "Detected Sway, launching waybar with Sway config"
    waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
elif pgrep -x "niri" > /dev/null; then
    echo "Detected Niri, launching waybar with Niri config"
    waybar -c ~/.config/waybar/config-niri.jsonc -s ~/.config/waybar/style.css &
else
    echo "No supported compositor detected, defaulting to Sway config"
    waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
fi
