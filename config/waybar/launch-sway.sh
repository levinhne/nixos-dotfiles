#!/bin/bash

# Kill any running waybar instances
killall waybar 2>/dev/null

# Wait for processes to terminate
sleep 0.5

# Launch waybar with Sway config
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
