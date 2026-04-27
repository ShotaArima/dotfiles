## セットアップ方法

### 0) リポジトリのクローン

SSH 鍵を GitHub に登録済みの場合:

```bash
git clone git@github.com:ShotaArima/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

SSH 鍵を未設定の場合は HTTPS でも clone できます。

```bash
git clone https://github.com/ShotaArima/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

### 1) Nix の確認

以下のコマンドが実行できれば、Nix はすでに利用可能です。

```bash
command -v nix
nix --version
```

表示される場合は、`2) Flakes の有効化` に進んでください。

---

### 1-1) Nix のインストール
- このShell Scriptを実行し、Nixをインストールしてください

```bash
bash nix-install.sh
```

- インストール後、新しいターミナルを開き直してください。

```bash
nix --version
```

> 補足: `nix: command not found` になる場合は、ターミナルを開き直すか、shell の初期化ファイルで PATH を上書きしていないか確認してください。

---

### 2) Flakes の有効化

このリポジトリでは `flake.nix` を使うため、Nix の experimental features を有効にします。

- ユーザー単位で設定する場合:

```bash
mkdir -p /etc/nix
${EDITOR:-vi} /etc/nix/nix.conf
```

- 以下を追記してください。

```conf
experimental-features = nix-command flakes
```

- 確認します。

```bash
nix flake --help
nix develop --help
```

> 補足: ユーザー単位で設定したい場合は `~/.config/nix` に同じ設定を書きます。
```bash
~/.config/nix
${EDITOR:-vi} ~/.config/nix/nix.conf
```

---

### 3) セットアップの実行

推奨手順は、Nix の開発シェルに入ってから `make setup` を実行する方法です。

```bash
cd ~/dotfiles
git pull
nix develop ./nix -c make setup
```

または、開発シェルに入らず 1 コマンドで実行することもできます。

```bash
cd ~/dotfiles
nix develop ./nix -c make setup
```

---

### 4) dotfiles 用ツールを profile に入れる場合

毎回 `nix develop` せずに `make` などを使いたい場合は、この flake が提供する `dotfiles-tools` を Nix profile にインストールできます。

```bash
nix profile install "github:ShotaArima/dotfiles?dir=nix#dotfiles-tools" --no-write-lock-file
```

インストール後、以下を確認します。

```bash
make --version
perl --version
```

その後、セットアップを実行します。

```bash
cd ~/dotfiles
git pull
make setup
```

> 補足: この手順は「Nix の PATH を通す」手順ではなく、「この dotfiles で必要なツールを Nix profile に追加する」手順です。

---

### 5) Nix shell の prompt 表示について

Nix shell に入っていることを prompt に表示する設定は任意です。
セットアップに必須ではありません。

bash の `nix develop` shell で prompt を変えたい場合は、`nix.conf` に以下のような設定を追加できます。

```conf
bash-prompt-prefix = (nix)
```

zsh / fish / starship などを使っている場合は、それぞれの prompt 側で設定する方が自然です。

---

## セットアップ方式の使い分け

| 方法 | 用途 |
|---|---|
| `nix develop ./nix` | 一時的に dotfiles 用の開発環境へ入る |
| `nix develop ./nix -c make setup` | 開発シェルに入らずセットアップだけ実行する |
| `nix profile install ...#dotfiles-tools` | `make` や `perl` を普段の profile に入れて使う |
| ホストの `make` / `perl` を使う | Nix を使わず従来通り実行する |

