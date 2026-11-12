-- Keybinds. Every bind has a description → SUPER+H lists them all.
local home     = os.getenv("HOME")
local scripts  = home .. "/.config/hypr/scripts"
local uscripts = home .. "/.config/hypr/UserScripts"

local term    = "kitty"
local files   = "thunar"
local browser = "flatpak run app.zen_browser.zen"

local function bind(keys, action, desc, opts)
  opts = opts or {}
  opts.description = desc
  return hl.bind(keys, action, opts)
end
local exec = hl.dsp.exec_cmd
local function emacs(fn) return exec("emacsclient -c -n -a '' -e '(" .. fn .. ")'") end

---------------------------------------------------------------- toggles (were hyprctl-keyword scripts)
local function notify(msg) hl.exec_cmd("notify-send -e -u low -t 1500 'Hyprland' '" .. msg .. "'") end

local function toggle_gamemode()
  local on = hl.get_config("animations.enabled")
  hl.config({ animations = { enabled = not on } })
  notify(on and "Animations OFF" or "Animations ON")
end

local function toggle_blur()
  local passes = hl.get_config("decoration.blur.passes")
  if passes and passes > 1 then
    hl.config({ decoration = { blur = { size = 2, passes = 1 } } })
    notify("Less blur")
  else
    hl.config({ decoration = { blur = { size = 6, passes = 3 } } })
    notify("Normal blur")
  end
end

local function toggle_layout()
  local layout = hl.get_config("general.layout")
  local next_layout = (layout == "master") and "dwindle" or "master"
  hl.config({ general = { layout = next_layout } })
  notify("Layout: " .. next_layout)
end

-- SUPER+J / SUPER+K: cycle windows in either layout
local function cycle(forward)
  return function()
    if hl.get_config("general.layout") == "master" then
      hl.dispatch(hl.dsp.layout(forward and "cyclenext" or "cycleprev"))
    else
      hl.dispatch(hl.dsp.window.cycle_next({ next = forward }))
    end
  end
end

-- SUPER+ALT+F: float / tile every window on the current workspace
local function toggle_all_float()
  local ws = hl.get_active_workspace()
  if not ws then return end
  for _, w in ipairs(hl.get_workspace_windows(ws)) do
    hl.dispatch(hl.dsp.window.float({ action = "toggle", window = w }))
  end
end

---------------------------------------------------------------- apps
bind("SUPER + Return",         exec(term),                                   "Terminal (kitty)")
bind("SUPER + SHIFT + Return", exec("pypr toggle term"),                     "Dropdown terminal")
bind("SUPER + C",              exec(browser),                                "Browser (Zen)")
bind("SUPER + code:21",        exec("qalculate-gtk"),                        "Calculator (Qalculate)")
bind("SUPER + ALT + C",        exec(uscripts .. "/RofiCalc.sh"),             "Quick calculator (rofi)")
bind("SUPER + D",              exec("pkill rofi || rofi -show combi -modes combi -combi-modes 'window,drun,run'"), "App launcher (rofi)")
bind("SUPER + A",              exec("pkill rofi; ags -t overview"),          "Workspace overview (ags)")
bind("SUPER + SHIFT + T",      exec(files),                                  "File manager (Thunar)")
bind("SUPER + S",              exec(scripts .. "/RofiSearch.sh"),            "Web search (rofi)")
bind("SUPER + ALT + E",        exec(scripts .. "/RofiEmoji.sh"),             "Emoji picker")
bind("SUPER + ALT + V",        exec(scripts .. "/ClipManager.sh"),           "Clipboard history")
bind("SUPER + SHIFT + M",      exec(uscripts .. "/RofiBeats.sh"),            "Online music (RofiBeats)")
bind("SUPER + SHIFT + O",      exec(uscripts .. "/ZshChangeTheme.sh"),       "Change oh-my-zsh theme")
bind("SUPER + Z",              exec("pypr zoom"),                            "Zoom desktop")

---------------------------------------------------------------- emacs (via the emacs daemon)
bind("SUPER + E",              emacs("my/vterm"),                "Emacs: vterm")
bind("SUPER + N",              emacs("my/open-dashboard"),       "Emacs: dashboard")
bind("SUPER + CTRL + N",       emacs("my/open-notes"),           "Emacs: notes.org")
bind("SUPER + T",              emacs("my/open-todos"),           "Emacs: todos / agenda")
bind("SUPER + O",              emacs("my/open-dired-home"),      "Emacs: dired ~")
bind("SUPER + SHIFT + C",      emacs("my/org-capture-anywhere"), "Emacs: org capture")

---------------------------------------------------------------- notifications, bar, look
bind("SUPER + SHIFT + N",      exec("swaync-client -t -sw"),                 "Notification center")
bind("SUPER + B",              exec("pkill -SIGUSR1 waybar"),                "Hide / show waybar")
bind("SUPER + CTRL + B",       exec(scripts .. "/WaybarStyles.sh"),          "Waybar style menu")
bind("SUPER + ALT + B",        exec(scripts .. "/WaybarLayout.sh"),          "Waybar layout menu")
bind("SUPER + ALT + R",        exec(scripts .. "/Refresh.sh"),               "Restart waybar / swaync / ags")
bind("SUPER + W",              exec(uscripts .. "/WallpaperSelect.sh"),      "Pick wallpaper (re-themes via wallust)")
bind("SUPER + SHIFT + W",      exec(uscripts .. "/WallpaperEffects.sh"),     "Wallpaper effects")
bind("CTRL + ALT + W",         exec(uscripts .. "/WallpaperRandom.sh"),      "Random wallpaper")
bind("SUPER + SHIFT + B",      toggle_blur,                                  "Toggle blur strength")
bind("SUPER + SHIFT + G",      toggle_gamemode,                              "Game mode (animations on/off)")
bind("SUPER + H",              exec(scripts .. "/KeyHints.sh"),              "Show this keybind list")
bind("SUPER + SHIFT + E",      exec(scripts .. "/QuickEdit.sh"),             "Edit Hyprland config")

-- Night light: colour temperature via wl-gammarelay
bind("SUPER + up",   exec("busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -500"), "Warmer screen (night light)", { repeating = true })
bind("SUPER + down", exec("busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +500"), "Cooler screen",               { repeating = true })

---------------------------------------------------------------- session
bind("SUPER + Q",              hl.dsp.window.close(),                        "Close window")
bind("SUPER + SHIFT + Q",      exec(scripts .. "/KillActiveProcess.sh"),     "Kill window's process")
bind("CTRL + ALT + L",         exec(scripts .. "/LockScreen.sh"),            "Lock screen")
bind("CTRL + ALT + P",         exec(scripts .. "/Wlogout.sh"),               "Power menu")
bind("CTRL + ALT + Delete",    hl.dsp.exit(),                                "Exit Hyprland")

---------------------------------------------------------------- windows
bind("SUPER + F",              hl.dsp.window.fullscreen(),                   "Fullscreen")
bind("SUPER + SHIFT + F",      hl.dsp.window.float({ action = "toggle" }),   "Float / tile window")
bind("SUPER + ALT + F",        toggle_all_float,                             "Float / tile all windows on workspace")
bind("SUPER + P",              hl.dsp.window.pseudo(),                       "Pseudotile (dwindle)")
bind("SUPER + G",              hl.dsp.group.toggle(),                        "Group / ungroup windows")
bind("SUPER + ALT + L",        toggle_layout,                                "Switch dwindle / master layout")
bind("SUPER + M",              hl.dsp.layout("splitratio 0.3"),              "Grow split ratio")
bind("SUPER + J",              cycle(true),                                  "Focus next window")
bind("SUPER + K",              cycle(false),                                 "Focus previous window")
bind("SUPER + I",              hl.dsp.layout("addmaster"),                   "Master: add master")
bind("SUPER + CTRL + D",       hl.dsp.layout("removemaster"),                "Master: remove master")
bind("SUPER + CTRL + Return",  hl.dsp.layout("swapwithmaster"),              "Master: swap with master")
bind("ALT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, "Cycle windows (bring to top)")

-- focus (up/down are the night-light keys; use SUPER+J/K to cycle)
bind("SUPER + left",           hl.dsp.focus({ direction = "left" }),         "Focus left")
bind("SUPER + right",          hl.dsp.focus({ direction = "right" }),        "Focus right")

-- move & resize
for key, dir in pairs({ left = "l", right = "r", up = "u", down = "d" }) do
  bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ direction = dir }), "Move window " .. key)
end
bind("SUPER + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), "Resize ←", { repeating = true })
bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), "Resize →", { repeating = true })
bind("SUPER + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), "Resize ↑", { repeating = true })
bind("SUPER + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), "Resize ↓", { repeating = true })

bind("SUPER + mouse:272", hl.dsp.window.drag(),   "Drag window",   { mouse = true })
bind("SUPER + mouse:273", hl.dsp.window.resize(), "Resize window", { mouse = true })

---------------------------------------------------------------- workspaces
-- number row by keycode (code:10 = 1 … code:19 = 0) so it works in the Arabic layout too
for i = 1, 10 do
  local key = "code:" .. (9 + i)
  bind("SUPER + " .. key,          hl.dsp.focus({ workspace = i }),                       "Go to workspace " .. i)
  bind("SUPER + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i }),                 "Move window to workspace " .. i)
  bind("SUPER + CTRL + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }), "Send window to workspace " .. i .. " (stay)")
end

bind("SUPER + Tab",             hl.dsp.focus({ workspace = "m+1" }), "Next workspace")
bind("SUPER + SHIFT + Tab",     hl.dsp.focus({ workspace = "m-1" }), "Previous workspace")
bind("SUPER + period",          hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind("SUPER + comma",           hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind("SUPER + mouse_down",      hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind("SUPER + mouse_up",        hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")

bind("SUPER + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1" }),                 "Move window to previous workspace")
bind("SUPER + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }),                 "Move window to next workspace")
bind("SUPER + CTRL + bracketleft",   hl.dsp.window.move({ workspace = "-1", follow = false }), "Send window to previous workspace")
bind("SUPER + CTRL + bracketright",  hl.dsp.window.move({ workspace = "+1", follow = false }), "Send window to next workspace")

-- scratchpad workspace
bind("SUPER + U",          hl.dsp.workspace.toggle_special("scratch"),             "Show / hide scratchpad")
bind("SUPER + SHIFT + U",  hl.dsp.window.move({ workspace = "special:scratch" }), "Move window to scratchpad")

---------------------------------------------------------------- media & volume keys
bind("XF86AudioRaiseVolume", exec(scripts .. "/Volume.sh --inc"),        "Volume up",   { locked = true, repeating = true })
bind("XF86AudioLowerVolume", exec(scripts .. "/Volume.sh --dec"),        "Volume down", { locked = true, repeating = true })
bind("XF86AudioMute",        exec(scripts .. "/Volume.sh --toggle"),     "Mute",        { locked = true })
bind("XF86AudioMicMute",     exec(scripts .. "/Volume.sh --toggle-mic"), "Mute mic",    { locked = true })
bind("XF86AudioPlay",        exec(scripts .. "/MediaCtrl.sh --pause"),   "Play / pause", { locked = true })
bind("XF86AudioPause",       exec(scripts .. "/MediaCtrl.sh --pause"),   "Play / pause", { locked = true })
bind("XF86AudioNext",        exec(scripts .. "/MediaCtrl.sh --nxt"),     "Next track",   { locked = true })
bind("XF86AudioPrev",        exec(scripts .. "/MediaCtrl.sh --prv"),     "Previous track", { locked = true })
bind("XF86AudioStop",        exec(scripts .. "/MediaCtrl.sh --stop"),    "Stop",         { locked = true })
bind("XF86Sleep",            exec("systemctl suspend"),                   "Suspend",      { locked = true })

---------------------------------------------------------------- screenshots
bind("SUPER + Print",               exec(scripts .. "/ScreenShot.sh --now"),    "Screenshot")
bind("SUPER + SHIFT + Print",       exec(scripts .. "/ScreenShot.sh --area"),   "Screenshot area")
bind("SUPER + CTRL + Print",        exec(scripts .. "/ScreenShot.sh --in5"),    "Screenshot in 5s")
bind("SUPER + CTRL + SHIFT + Print",exec(scripts .. "/ScreenShot.sh --in10"),   "Screenshot in 10s")
bind("ALT + Print",                 exec(scripts .. "/ScreenShot.sh --active"), "Screenshot active window")
bind("SUPER + SHIFT + S",           exec(scripts .. "/ScreenShot.sh --swappy"), "Screenshot area → edit (swappy)")
