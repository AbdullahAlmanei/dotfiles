-- Window & layer rules

local function rule(match, effects) effects.match = match; return hl.window_rule(effects) end

---------------------------------------------------------------- general
-- Ignore apps asking to maximize themselves
rule({ class = ".*" }, { name = "suppress-maximize", suppress_event = "maximize" })

-- Don't let the screen idle/lock while something is fullscreen (videos, games)
rule({ fullscreen = true }, { name = "idle-inhibit-fullscreen", idle_inhibit = "fullscreen" })

-- Fix XWayland drag-and-drop ghosts
rule({ class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
     { name = "fix-xwayland-drags", no_focus = true })

---------------------------------------------------------------- floating tools & dialogs
local floaters = {
  "^(org.pulseaudio.pavucontrol|pavucontrol)$",
  "^(nm-connection-editor|nm-applet|blueman-manager)$",
  "^(nwg-look|qt5ct|qt6ct|kvantummanager)$",
  "^(qalculate-gtk)$",
  "^(org.gnome.Calculator)$",
  "^(yad)$",
  "^(eog|org.gnome.eog)$",
  "^(mpv)$",
  "^(file-roller|org.gnome.FileRoller)$",
  "^(xdg-desktop-portal-gtk)$",
  "^(hyprland-share-picker)$",
  "^(org.hyprland.hyprpolkitagent|hyprpolkitagent)$",
  "^([Zz]oom)$",
}
for i, cls in ipairs(floaters) do
  rule({ class = cls }, { name = "float-" .. i, float = true, center = true })
end

rule({ class = "^([Tt]hunar)$", title = "^(File Operation Progress|Confirm to replace files)$" },
     { name = "thunar-dialogs", float = true, center = true })

-- Sensible default sizes for the bigger floaters
rule({ class = "^(xdg-desktop-portal-gtk)$" },        { name = "size-portal",  size = "60% 65%" })
rule({ class = "^(org.pulseaudio.pavucontrol|pavucontrol)$" }, { name = "size-pavu", size = "45% 55%" })
rule({ class = "^(qalculate-gtk)$" },                  { name = "size-qalc",    size = "30% 45%" })
rule({ class = "^(nwg-look|qt5ct|qt6ct|kvantummanager)$" }, { name = "size-themes", size = "55% 65%" })

---------------------------------------------------------------- picture-in-picture
rule({ title = "^(Picture-in-Picture)$" }, {
  name = "pip", float = true, pin = true,
  size = "25% 25%", move = "72% 7%",
  opacity = "1.0 override 0.85 override",
  keep_aspect_ratio = true,
})

---------------------------------------------------------------- workspaces per app
rule({ class = "^([Tt]hunderbird)$" },                      { name = "ws-mail",   workspace = "1" })
rule({ class = "^([Ss]team|[Ll]utris)$" },                  { name = "ws-games",  workspace = "5" })
rule({ class = "^(virt-manager)$" },                        { name = "ws-vm",     workspace = "6 silent" })
rule({ class = "^([Dd]iscord|[Vv]esktop|[Ww]eb[Cc]ord|[Ss]lack)$" }, { name = "ws-chat", workspace = "7" })

-- Games: allow tearing for lower latency
rule({ class = "^(steam_app_.*|gamescope)$" }, { name = "games-immediate", immediate = true })

---------------------------------------------------------------- layers (bars, menus, panels)
local blurred = {
  { "^(waybar)$",                     0.1 },
  { "^(rofi)$",                       0.1 },
  { "^(swaync-control-center)$",      0.1 },
  { "^(swaync-notification-window)$", 0.1 },
  { "^(logout_dialog)$",              0.1 },
  { "^(overview)$",                   0.1 }, -- ags overview (SUPER+A)
}
for i, l in ipairs(blurred) do
  hl.layer_rule({ name = "blur-layer-" .. i, match = { namespace = l[1] }, blur = true, ignore_alpha = l[2] })
end

hl.layer_rule({ name = "swaync-slide", match = { namespace = "^(swaync-control-center)$" }, animation = "slide right" })
