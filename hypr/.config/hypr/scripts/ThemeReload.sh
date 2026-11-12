#!/usr/bin/env bash
# Push freshly generated wallust colours to running apps.
# Called after `wallust run` (wallpaper change / login).

# Hyprland borders, groups, shadows (conf/colors.lua was rewritten)
hyprctl reload >/dev/null 2>&1

# kitty re-reads its config (incl. colors-wallust.conf) on SIGUSR1
pkill -USR1 -x kitty 2>/dev/null

# swaync: reload CSS without restarting
swaync-client -rs >/dev/null 2>&1

# Spotify via spicetify: rebuild theme colours; restart Spotify only if it's open
SPICETIFY="$HOME/.spicetify/spicetify"
if [ -x "$SPICETIFY" ]; then
  "$SPICETIFY" -q refresh >/dev/null 2>&1
  if pgrep -f com.spotify.Client >/dev/null || pgrep -x spotify >/dev/null; then
    "$SPICETIFY" -q restart >/dev/null 2>&1
  fi
fi
