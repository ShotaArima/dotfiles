# dotfiles

## 構成

```bash

~/dotfiles
├── README.md
├── bin/                    # どのマシンでも使いたい自作スクリプト
│   └── backup-xxx.sh
├── shell/
│   ├── common.sh           # すべてのシェル共通 (PATH, alias, env)
│   ├── zsh/
│   │   ├── main.zsh        # Zsh共通設定
│   │   ├── prompt.zsh
│   │   └── completion.zsh
│   ├── bash/
│   │   └── main.bash       # Bash用設定
│   └── powershell/
│       └── profile.ps1     # Windows用 (あれば)
├── host/
│   ├── macbook-pro.local.zsh    # ホスト固有の設定
│   ├── datacomp-ubuntu.zsh
│   └── wsl-ubuntu.zsh
├── os/
│   ├── mac.zsh             # macOS向け (brew 関連とか)
│   ├── linux.zsh           # Linux向け
│   └── windows.ps1         # Windows向け
├── bootstrap/
│   ├── install.sh          # 初期設定スクリプト (symlink貼るなど)
│   └── detect_os.sh        # OS検出など
└── config/
    ├── gitconfig           # 共通の git 設定
    └── starship.toml       # プロンプトツール等の設定

```
