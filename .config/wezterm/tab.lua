local wezterm = require("wezterm")
local module = {}

-- -----------------------------------------------------------------------------
-- 色の設定: ここを書き換えるだけで配色を変えられます
-- -----------------------------------------------------------------------------
local COLORS = {
  -- アクティブ（選択中）タブ
  active_bg = "#80EBDF", -- 背景色
  active_fg = "#313244", -- 文字色

  -- 非アクティブタブ
  inactive_bg = "none", -- "none" で透過
  inactive_fg = "#a0a9cb",

  -- 右ステータス（メモリ・時計）
  mem_fg = "#80EBDF", -- メモリ使用量の色
  clock_fg = "#a0a9cb", -- 時計の色
}

-- タブの左右につける半円（丸タブの見た目を作る）
local LEFT_CIRCLE = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_CIRCLE = wezterm.nerdfonts.ple_right_half_circle_thick

-- 右ステータス用アイコン（フォントに無ければ "" になるよう or で保険）
local MEM_ICON = wezterm.nerdfonts.md_memory or ""
local CLOCK_ICON = wezterm.nerdfonts.md_clock_time_four_outline or ""

-- メモリ使用量を "XX.XXGB (XX%)" 形式で取得するシェルコマンド（OSごとに切替）
-- WezTerm の Lua には直接メモリを取る API が無いため、子プロセスで取得する。
local MEM_CMD
if wezterm.target_triple:find("darwin") then
  -- macOS: 使用量 = (active + wired + compressed) ページ × ページサイズ
  MEM_CMD = [[
    PS=$(sysctl -n hw.pagesize)
    TOTAL=$(sysctl -n hw.memsize)
    USED=$(vm_stat | awk -v ps="$PS" '
      /Pages active/            {gsub(/\./,"",$3); a=$3}
      /Pages wired down/        {gsub(/\./,"",$4); w=$4}
      /occupied by compressor/  {gsub(/\./,"",$5); c=$5}
      END { print (a+w+c)*ps }')
    awk -v u="$USED" -v t="$TOTAL" 'BEGIN{ printf "%.2fGB (%.0f%%)", u/1073741824, u/t*100 }'
  ]]
else
  -- Linux: /proc/meminfo の MemTotal - MemAvailable を使用量とみなす（単位は kB）
  MEM_CMD = [[
    awk '/MemTotal/{t=$2} /MemAvailable/{a=$2}
      END{ u=t-a; printf "%.2fGB (%.0f%%)", u/1048576, u/t*100 }' /proc/meminfo
  ]]
end

-- 子プロセスを実行してメモリ文字列を得る。失敗時は "" を返す。
local function get_memory()
  local ok, stdout = wezterm.run_child_process({ "sh", "-c", MEM_CMD })
  if ok and stdout and stdout ~= "" then
    return (stdout:gsub("%s+$", "")) -- 末尾の改行・空白を除去
  end
  return ""
end

-- -----------------------------------------------------------------------------
-- メイン処理
-- -----------------------------------------------------------------------------
function module.apply_to_config(config)
  -- タブバー自体の設定
  config.use_fancy_tab_bar = false -- レトロスタイル（フォント設定が効く）
  -- config.tab_bar_at_bottom = true -- タブバーを下に表示
  config.hide_tab_bar_if_only_one_tab = false -- タブが1つでも表示する
  config.show_new_tab_button_in_tab_bar = false -- 「+」ボタンを消す
  config.tab_max_width = 30 -- タブの最大幅

  -- タブのタイトルを描画する
  wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
    -- アクティブかどうかで色を切り替える
    local bg = tab.is_active and COLORS.active_bg or COLORS.inactive_bg
    local fg = tab.is_active and COLORS.active_fg or COLORS.inactive_fg

    -- タブ番号 + パネルのタイトル
    -- 左の余白(1) + 左右の半円(2) のぶんを max_width から引いて切り詰めないと、
    -- タブ幅の上限を超えて右の半円が切れる
    local title = string.format(" %d: %s ", tab.tab_index + 1, tab.active_pane.title)
    title = wezterm.truncate_right(title, max_width - 3)

    -- 半円はアクティブタブだけに付ける
    local left = tab.is_active and LEFT_CIRCLE or ""
    local right = tab.is_active and RIGHT_CIRCLE or ""

    -- 描画パーツを順番に並べて返す
    return {
      -- 左の半円（背景色を文字色として描くことで丸く見せる）
      { Background = { Color = "none" } },
      { Foreground = { Color = bg } },
      { Text = " " .. left },
      -- タイトル本体
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = title },
      -- 右の半円
      { Background = { Color = "none" } },
      { Foreground = { Color = bg } },
      { Text = right },
    }
  end)

  -- タブバー右側にメモリ使用量と時計を表示する
  -- 既定では約1秒ごとに呼ばれる（config.status_update_interval で変更可）
  wezterm.on("update-status", function(window, _)
    local mem = get_memory()
    local time = wezterm.strftime("%m/%d (%a) %H:%M")

    window:set_right_status(wezterm.format({
      -- メモリ使用量（XX.XXGB (XX%)）
      { Foreground = { Color = COLORS.mem_fg } },
      { Text = MEM_ICON .. " " .. mem .. "   " },
      -- 時計
      { Foreground = { Color = COLORS.clock_fg } },
      { Text = CLOCK_ICON .. " " .. time .. " " },
    }))
  end)
end

return module