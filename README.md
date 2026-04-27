# dotfiles

## 構成

```bash
~/dotfiles
├── README.md
├── back-up/
│   └── 既存の設定ファイルの退避先
├── bootstrap/
│   └── mac_zsh.pm
├── docs
│   └── mac.md
├── makefile
├── .gitignore
└── config/
    ├── .zprofile
    └── .zshrc
```

## セットアップ方法
```bash
git clone https://github.com/ShotaArima/dotfiles.git ~/dotfiles
cd ~/dotfiles
make setup
```
## テスト（GitHub Actions）

`push` と `pull_request` のタイミングで、以下を自動実行します。

- `bootstrap/mac_zsh.pm` の構文チェック（`perl -c`）
- 一時 `HOME` を使ったセットアップの統合テスト（バックアップ作成とシンボリックリンク作成の確認）
