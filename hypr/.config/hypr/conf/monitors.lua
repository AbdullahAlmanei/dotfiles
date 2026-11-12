-- Displays. Edit here (SUPER+SHIFT+E → monitors.lua); Hyprland reloads on save.
-- See what your screen supports:  hyprctl monitors   (look at "availableModes")
--
-- mode     = "WIDTHxHEIGHT@HZ"   e.g. "2560x1440@99.99", or "preferred"
-- position = "XxY" of the top-left corner, or "auto"
-- scale    = 1 (100%), 1.25, 1.5 …

-- BenQ PD2706QN (27", native 2560x1440, max 100 Hz) — matched by name, so any port works
hl.monitor({ output = "desc:BNQ BenQ PD2706QN", mode = "2560x1440@99.99", position = "0x0", scale = 1 })

-- Anything else that gets plugged in: its preferred mode, placed to the right
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
