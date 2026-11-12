-- Started once, when Hyprland starts (old exec-once)
local scripts = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.on("hyprland.start", function()
  -- session plumbing
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  -- wallpaper (+ wallust colors) — restores the last one, rug.jpg on first boot
  hl.exec_cmd(scripts .. "/WallpaperRestore.sh")

  -- bar, notifications, overview, tray
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaync")
  hl.exec_cmd("ags")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("blueman-applet")

  -- night light daemon (SUPER+Up / SUPER+Down change the temperature)
  hl.exec_cmd("wl-gammarelay")

  -- emacs server, so SUPER+E / N / T / O open instantly via emacsclient
  hl.exec_cmd("emacs --daemon")

  -- clipboard history (SUPER+ALT+V)
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  -- idle/lock, dropdown terminal + zoom
  hl.exec_cmd("hypridle")
  hl.exec_cmd("pypr")
end)
