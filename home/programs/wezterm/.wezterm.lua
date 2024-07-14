-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha"

local color_scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

config.background = {
	{
		source = { Color = color_scheme.background },
		opacity = 0.8,
		height = "100%",
		width = "100%",
	},
}

config.font = wezterm.font_with_fallback({
	{ family = "Cascadia Code", harfbuzz_features = { "calt=1", "ss01=1" } },
	-- { family = "Fira Code", harfbuzz_features = { "zero=1", "cv14=1", "ss04=1", "ss06" } },
	-- { family = "JetBrains Mono", harfbuzz_features = { "cv14=1" } },
	-- { family = "Lilex", harfbuzz_features = { "cv09=1", "ss03=1" } },
	-- { family = "MonoLisa", harfbuzz_features = { "ss02=1", "ss04=1", "ss08=1", "ss11=1", "ss12=1" } },
	-- { family = "Maple Mono", harfbuzz_features = { "cv03=1", "ss01=1", "ss02=1", "ss04=1" } },
	"Symbols Nerd Font",
})

config.font_size = 11.0
-- config.line_height = 0.9

config.enable_wayland = true
config.front_end = "WebGpu"

config.use_fancy_tab_bar = false

config.initial_cols = 120
config.initial_rows = 30

-- and finally, return the configuration to wezterm
return config
