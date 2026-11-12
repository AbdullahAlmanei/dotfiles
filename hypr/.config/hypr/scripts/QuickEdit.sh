#!/usr/bin/env bash
# SUPER+SHIFT+E: pick a Hyprland config file and open it in Emacs.
# Hyprland reloads automatically when you save.
pkill rofi && exit 0
dir="$HOME/.config/hypr"
choice=$(
  { ls "$dir"/conf/*.lua; echo "$dir/hyprland.lua"; echo "$dir/hypridle.conf"; echo "$dir/hyprlock.conf"; echo "$dir/pyprland.toml"; } \
  | grep -v '/colors.lua$' | sed "s|$dir/||" | rofi -dmenu -i -p "Edit"
)
[ -n "$choice" ] && emacsclient -c -n -a '' "$dir/$choice"
