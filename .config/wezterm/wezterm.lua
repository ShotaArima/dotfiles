local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.font = wezterm.font("JetBrains Mono") 
config.font_size = 18.0

-- 背景を透過
config.window_background_opacity = 0.5
-- ぼかしを追加
config.macos_window_background_blur = 1

-- other settings
require("appearance").apply_to_config(config)
require("tab").apply_to_config(config)

-- keybinds.lua は { keys = ..., key_tables = ... } の素のテーブルを返すため、
-- apply_to_config ではなく直接マージする
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

-- Leaderの認識
config.leader = {
  key = ";",
  mods = "CTRL",
  timeout_milliseconds = 2000,
}

-- QuickSelect: デフォルトのパターンを無効化し、拾う対象を絞る
-- （Cmd+Space での起動キーは keybinds.lua 側に定義）
config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
  "\\b[0-9a-f]{7,40}\\b", -- Git commit hash
}

return config
