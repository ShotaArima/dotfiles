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