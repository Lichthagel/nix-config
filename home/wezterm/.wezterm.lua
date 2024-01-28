-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font_with_fallback({
  { family = "Cascadia Code", harfbuzz_features = { "calt=1", "ss01=1" } },
  -- { family = "Fira Code", harfbuzz_features = { "zero=1", "cv14=1", "ss04=1", "ss06" } },
  -- { family = "JetBrains Mono", harfbuzz_features = { "cv14=1" } },
  -- { family = "Lilex", harfbuzz_features = { "cv09=1", "ss03=1" } },
  -- { family = "MonoLisa", harfbuzz_features = { "ss02=1", "ss04=1", "ss08=1", "ss11=1", "ss12=1" } },
  "Symbols Nerd Font",
})

config.font_size = 11.0
-- config.line_height = 0.9
-- config.front_end = "WebGpu"

wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(config, {
  position = "bottom",
  max_width = 32,
  dividers = "slant_right",
  indicator = {
    leader = {
      enabled = false,
      off = " ",
      on = " ",
    },
    mode = {
      enabled = true,
      names = {
        resize_mode = "RESIZE",
        copy_mode = "VISUAL",
        search_mode = "SEARCH",
      },
    },
  },
  tabs = {
    numerals = "arabic",        -- or "roman"
    pane_count = "superscript", -- or "subscript", false
    brackets = {
      active = { "", ":" },
      inactive = { "", ":" },
    },
  },
  clock = {           -- note that this overrides the whole set_right_status
    enabled = false,
    format = "%H:%M", -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
  },
})

config.enable_wayland = false

-- and finally, return the configuration to wezterm
return config
