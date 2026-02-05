#!/bin/bash

# Check for updates with priority: yay > paru > pacman

if command -v yay &> /dev/null; then
    # Use yay if available
    yay -Qu 2>/dev/null | wc -l
elif command -v paru &> /dev/null; then
    # Use paru if available
    paru -Qu 2>/dev/null | wc -l
elif command -v checkupdates &> /dev/null; then
    # Fallback to checkupdates (pacman)
    checkupdates 2>/dev/null | wc -l
else
    # If nothing is available, return 0
    echo 0
fi
