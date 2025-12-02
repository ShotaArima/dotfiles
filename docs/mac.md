# MacOS用セットアップ

## 前提条件
- gitコマンドが使用できる
- Zshターミナルである

---

## 1. 初回設定

1. dotfilesリポジトリのクローン

    ```bash
    $ git clone https://github.com/ShotaArima/dotfiles.git ~/dotfiles
    $ cd ~/dotfiles
    ```

2. Zshセットアップのスクリプトを実行

    ```bash
    $ ./bootstrap/macos_zsh.sh
    ```

---

## 2. 更新時手順

### (1) 変更を行う端末（普段使っている Mac）

変更は **必ず `~/dotfiles/config/`** の中で行う。

例）`.zshrc` を編集する：

```bash
$ vim ~/dotfiles/config/.zshrc
```

変更したら、リモートへ反映：

```bash
$ cd ~/dotfiles
$ git add .
$ git commit -m "Update zshrc"
$ git push
```

---

### (2) 設定を反映したい端末（別の Mac）

リポジトリを最新化する：

```bash
$ cd ~/dotfiles
$ git pull
```

必要であれば設定を再読み込み：

```bash
$ source ~/.zshrc
```

これで最新設定が適用される。
