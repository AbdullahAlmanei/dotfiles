#!/usr/bin/env bash
# Start swww and restore the last wallpaper (rug.jpg on first boot),
# then regenerate wallust colors for it.
DEFAULT="$HOME/Pictures/wallpapers/rug.jpg"
CURRENT="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

pgrep -x swww-daemon >/dev/null || swww-daemon --format xrgb &
for _ in $(seq 1 50); do swww query >/dev/null 2>&1 && break; sleep 0.1; done

wall="$DEFAULT"
[ -f "$CURRENT" ] && wall="$CURRENT"

swww img "$wall" --transition-type none
ln -sf "$wall" "$HOME/.config/rofi/.current_wallpaper"
wallust run -s -q "$wall"
"$HOME/.config/hypr/scripts/ThemeReload.sh"
