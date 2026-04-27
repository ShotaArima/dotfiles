# dotfiles

## 構成

```bash
~/dotfiles
├── README.md
├── back-up/
│   └── 既存の設定ファイルの退避先
├── bootstrap/
│   ├── setup.pm
│   └── mac_zsh.pm (legacy)
├── docs
│   └── mac.md
├── nix
│   └── flake.nix
├── makefile
├── .gitignore
└── config/
    ├── .zprofile            # 共通 fallback
    ├── .zshrc               # 共通 fallback
    ├── mac/
    │   └── .bashrc          # macOS 専用
    └── linux/
        └── .bashrc          # Linux 専用
```

## セットアップ方法

```bash
git clone https://github.com/ShotaArima/dotfiles.git ~/dotfiles
cd ~/dotfiles
make setup
```
## テスト（GitHub Actions）

`push` と `pull_request` のタイミングで、以下を自動実行します。

- `nix` コマンドの実行確認（`nix --version` / `nix profile --help`）
- `bootstrap/mac_zsh.pm` の構文チェック（`perl -c`）
- 一時 `HOME` を使ったセットアップの統合テスト（バックアップ作成とシンボリックリンク作成の確認）

## OS別の設定ファイル解決ルール

`make setup` は実行中OSを自動判定して、以下の優先順でシンボリックリンク元を決定します。

1. `config/<os>/<ファイル名>`
2. `config/<ファイル名>`（共通 fallback）

例:

- macOS で `.bashrc` を張る場合: `config/mac/.bashrc` を優先
- Linux で `.bashrc` を張る場合: `config/linux/.bashrc` を優先
- OS専用ファイルが無い場合: `config/.zshrc` など共通ファイルを利用

対象ファイル:

- `.zshrc`
- `.zprofile`
- `.bashrc`
- `.bash_profile`
- `.profile`

既存ファイルがシンボリックリンク以外の場合、`back-up/<timestamp>/` へ退避してからリンクを作成します。
