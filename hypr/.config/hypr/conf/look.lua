-- Look & feel. Colors come from the wallpaper via wallust (conf/colors.lua),
-- so changing wallpaper (SUPER+W) re-themes borders, groups and shadows too.

-- Fallback palette if wallust hasn't generated colors yet
local ok, c = pcall(require, "conf.colors")
if not ok or type(c) ~= "table" then
  c = {
    background = "1e1e2e", foreground = "cdd6f4",
    color0 = "1e1e2e", color4 = "89b4fa", color5 = "cba6f7", color6 = "94e2d5",
    color8 = "45475a", color12 = "89b4fa", color13 = "cba6f7", color14 = "94e2d5", color15 = "cdd6f4",
  }
end

local function rgba(hex, alpha) return "rgba(" .. hex .. (alpha or "ff") .. ")" end

hl.config({
  general = {
    gaps_in     = 4,
    gaps_out    = 8,
    border_size = 2,
    col = {
      active_border   = { colors = { rgba(c.color12), rgba(c.color14) }, angle = 45 },
      inactive_border = rgba(c.color8, "aa"),
    },
    layout          = "dwindle",
    resize_on_border = true,
    allow_tearing   = true, -- lets games tear when they ask for it
  },

  decoration = {
    rounding       = 12,
    rounding_power = 2,

    -- slightly see-through so blur shows; terminals are kept opaque in rules.lua
    active_opacity     = 0.95,
    inactive_opacity   = 0.85,
    fullscreen_opacity = 1.0,

    dim_inactive = true,
    dim_strength = 0.08,
    dim_special  = 0.3,

    shadow = {
      enabled        = true,
      range          = 14,
      render_power   = 3,
      color          = rgba(c.color0, "99"),
      color_inactive = rgba(c.color0, "55"),
    },

    blur = {
      enabled            = true,
      size               = 6,
      passes             = 3,
      new_optimizations  = true,
      ignore_opacity     = true,
      xray               = false,
      vibrancy           = 0.2,
      vibrancy_darkness  = 0.5,
      noise              = 0.01,
      popups             = true,
      popups_ignorealpha = 0.2,
      special            = true,
    },
  },

  group = {
    col = {
      border_active   = { colors = { rgba(c.color13), rgba(c.color12) }, angle = 45 },
      border_inactive = rgba(c.color8, "aa"),
    },
    groupbar = {
      font_size  = 11,
      height     = 16,
      rounding   = 6,
      gradients  = true,
      text_color = rgba(c.foreground),
      col = {
        active   = rgba(c.color4, "cc"),
        inactive = rgba(c.color8, "88"),
      },
    },
  },

  -- Off by default (snappy). SUPER+SHIFT+G toggles them on/off.
  animations = { enabled = false },

  dwindle = {
    preserve_split       = true,
  },

  master = {
    new_status           = "master",
    new_on_top           = true,
    mfact                = 0.5,
  },

  misc = {
    disable_hyprland_logo    = true,
    disable_splash_rendering = true,
    force_default_wallpaper  = 0,
    mouse_move_enables_dpms  = true,
    key_press_enables_dpms   = true,
    enable_swallow           = true,
    swallow_regex            = "^(kitty)$",
    focus_on_activate        = false,
    vrr                      = 2, -- VRR only for fullscreen apps (games/video)
  },

  render = {
    direct_scanout = false, -- was off on the laptop too; set 2 to try it for games
  },

  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles   = true,
    pass_mouse_when_bound    = false,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  ecosystem = {
    no_update_news = true,
  },
})

-- Animation curves (used when animations are toggled on)
hl.curve("wind",   { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winIn",  { type = "bezier", points = { {0.1, 1.1},  {0.1, 1.1}  } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1}      } })
hl.curve("liner",  { type = "bezier", points = { {1, 1},      {1, 1}      } })

hl.animation({ leaf = "windows",     enabled = true, speed = 6,   bezier = "wind",   style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,   bezier = "winIn",  style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,   bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,   bezier = "wind",   style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 1,   bezier = "liner" })
hl.animation({ leaf = "fade",        enabled = true, speed = 10,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,   bezier = "wind" })

-- Special workspace (scratchpad, SUPER+U): windows float in the middle at ~85% size.
-- Replaces the deprecated dwindle/master special_scale_factor (0.85 on 2560x1440 ≈ 108px / 192px margins).
hl.workspace_rule({ workspace = "s[true]", gaps_out = { top = 108, right = 192, bottom = 108, left = 192 } })
