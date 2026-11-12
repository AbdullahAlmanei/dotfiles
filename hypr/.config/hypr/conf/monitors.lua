-- Main display: 2560x1440 on HDMI-A-1, highest refresh rate it offers
hl.monitor({ output = "HDMI-A-1", mode = "highrr", position = "0x0", scale = 1 })

-- Anything else that gets plugged in: sensible defaults, placed to the right
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
