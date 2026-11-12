#!/usr/bin/env bash
# SUPER+H: searchable list of every keybind, built live from the descriptions in conf/keybinds.lua
pkill rofi && exit 0

hyprctl binds -j | jq -r '
  def mods($m): [
    (if ($m / 64 | floor) % 2 == 1 then "SUPER" else empty end),
    (if ($m / 4  | floor) % 2 == 1 then "CTRL"  else empty end),
    (if ($m / 8  | floor) % 2 == 1 then "ALT"   else empty end),
    (if $m % 2 == 1                 then "SHIFT" else empty end)
  ];
  def keyname($k; $c):
    if $k != "" then $k
    elif ($c >= 10 and $c <= 19) then (if $c == 19 then "0" else ($c - 9 | tostring) end)
    elif $c == 21 then "="
    else "code:\($c)" end;
  .[] | select(.description != null and .description != "")
      | ((mods(.modmask) + [keyname(.key; .keycode)]) | join(" + ")) as $combo
      | "\($combo)\t\(.description)"
' | awk -F'\t' '!seen[$0]++ { printf "%-32s %s\n", $1, $2 }' \
  | rofi -dmenu -i -p "Keybinds" -no-custom -theme-str 'window { width: 55%; } listview { lines: 18; }' >/dev/null
