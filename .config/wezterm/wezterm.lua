local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

-- config.font_size = 14.0
-- config.font = wezterm.font( 
--   "HackGen Console NF" 
-- ) 

config.font = wezterm.font("JetBrains Mono") 
config.font_size = 18.0

-- 背景を透過
config.window_background_opacity = 0.85
-- ぼかしを追加
config.macos_window_background_blur = 20

return config