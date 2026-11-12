hl.config({
  input = {
    kb_layout  = "us,ara",
    kb_options = "grp:win_space_toggle", -- SUPER+SPACE switches English/Arabic

    repeat_rate  = 50,
    repeat_delay = 300,
    numlock_by_default = true,

    follow_mouse = 1,
    float_switch_override_focus = 0,
    sensitivity  = 0,

    touchpad = {
      natural_scroll       = true,
      disable_while_typing = true,
      tap_to_click         = true,
      scroll_factor        = 0.28,
    },
  },
})
