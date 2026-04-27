# MacOS用セットアップ

## 前提条件
- Zshターミナルである
- 以下のコマンドが実行できる
    - `git`
    - `perl`
    - `make`

## 1. 初回設定

### 1-i. dotfilesリポジトリのクローン

```bash
$ git clone https://github.com/ShotaArima/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
```

### 1-ii. セットアップを実行

```bash
$ make setup
```

> `make setup` は macOS を自動判定し、`config/mac/` → `config/` の順で設定ファイルを探してリンクします。

## 2. 更新時手順

### 2-i 変更を行う端末（普段使っている Mac）
- 変更は **`~/dotfiles/config/`（必要に応じて `mac/`）** の中で行う。
- 例）`.zshrc` を編集する：

```bash
$ vim ~/dotfiles/config/.zshrc
```

- 変更したら、リモートへ反映：

```bash
$ cd ~/dotfiles
$ git add .
$ git commit -m "Update zshrc"
$ git push
```

### 2-ii 設定を反映したい端末（別の Mac）

- リポジトリを最新化して、再適用する：

```bash
$ cd ~/dotfiles
$ git pull
$ make setup
```

- これで最新設定が適用される。
