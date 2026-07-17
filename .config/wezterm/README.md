# WezTerm Configuration

## directory structure
```bash
~/.config/wezterm/
├── wezterm.lua    # エントリ (これだけが読まれる)
├── keymaps.lua    # キーバインド
├── appearance.lua # 見た目
└── tab.lua        # タブバー
```

## セットアップ（シンボリックリンク）

このリポジトリの `.config/wezterm/` を `~/.config/wezterm` へ**ディレクトリごと**リンクする。

```bash
make wezterm     # WezTerm だけリンク
# または
make setup       # OS 設定 + WezTerm をまとめて
```

- リンクのターゲットは常に絶対パス（`~/.config/wezterm -> <dotfiles>/.config/wezterm`）。
- 既に実体があれば `back-up/<日時>/` へ退避してからリンクする。
- 冪等：既にリンク済みなら何もしない（何度実行しても安全）。

## 開発中の新規ファイルについて

`~/.config/wezterm` は**ディレクトリ自体がシンボリックリンク**なので、
このリポジトリ内 `.config/wezterm/` にファイルを追加・削除・リネームすると
**そのまま `~/.config/wezterm` 側に反映される。`make wezterm` の再実行は不要。**

```bash
# 例: 新しいモジュールを追加
touch .config/wezterm/colors.lua
ls -l ~/.config/wezterm/colors.lua   # すぐに見える
```

追加したファイルは `wezterm.lua` から読み込んで初めて有効になる。

```lua
-- wezterm.lua
local colors = require("colors")   -- 拡張子なし・同ディレクトリ内で解決される
```

反映を確認する手順：

1. リンクが張られているか確認
   ```bash
   readlink ~/.config/wezterm
   # => <dotfiles>/.config/wezterm （絶対パスならOK）
   ```
2. WezTerm 側で設定を再読み込み
   - 自動リロード（`wezterm.lua` の `automatically_reload_config`、既定で有効）で保存時に反映される。
   - 手動で再読み込みしたい場合は `Ctrl + Shift + R`。

> 個別ファイルではなくディレクトリ単位でリンクしているのがポイント。
> もしファイル単位でリンクしていると新規ファイルごとに貼り直しが必要になるが、
> この構成ではその手間がない。