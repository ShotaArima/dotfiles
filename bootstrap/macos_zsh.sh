#!/usr/bin/env bash
set -euo pipefail

# dotfiles リポジトリの場所（環境変数 DOTFILES で上書き可能）
DOTFILES_DIR="${DOTFILES:-$HOME/dotfiles}"

# バックアップ先ディレクトリ(タイムスタンプ付き)
BACKUP_DIR="$DOTFILES_DIR/back-up/$(date +%Y%m%d_%H%M%S)"

# このスクリプトで管理対象とする設定ファイル一覧（HOME 側の名前）
FILES=(
  ".zshrc"
  ".zprofile"
  # ".gitconfig"
)

# dotfiles 側で設定ファイルを置くディレクトリ
CONFIG_DIR="$DOTFILES_DIR/config"

echo "[INFO] DOTFILES_DIR = $DOTFILES_DIR"
echo "[INFO] BACKUP_DIR   = $BACKUP_DIR"
echo "[INFO] CONFIG_DIR   = $CONFIG_DIR"

# dotfiles と back-up のベースディレクトリを作成
mkdir -p "$DOTFILES_DIR" "$BACKUP_DIR"

# 対象ファイルごとに処理を回す
for f in "${FILES[@]}"; do
  home_f="$HOME/$f" # HOME 側のパス
  repo_f="$CONFIG_DIR/$f" # dotfiles 側のパス
  backup_f="$BACKUP_DIR/$f" # バックアップ先のパス（退避用）

  echo "------------------------------"
  echo "[TARGET] $home_f"

  # 1. 既存ファイルのバックアップ & dotfiles へのインポート
  if [ -e "$home_f" ] && [ ! -L "$home_f" ]; then
    echo "[INFO] Backup   : $home_f -> $backup_f"
    mkdir -p "$(dirname "$backup_f")"
    cp "$home_f" "$backup_f"

    echo "[INFO] Import   : $home_f -> $repo_f"
    mkdir -p "$(dirname "$repo_f")"
    cp "$home_f" "$repo_f"

  # すでにシンボリックリンクだった場合は、「すでに dotfiles 管理済み」とみなして何もしない
  elif [ -L "$home_f" ]; then
    echo "[SKIP] $home_f は既にシンボリックリンクのため import をスキップします"

  # ファイル自体が無い場合はバックアップもインポートも不要
  else
    echo "[INFO] $home_f は存在しません"
  fi

  # 2. dotfiles 側にファイルがない場合は空ファイルを作る
  if [ ! -e "$repo_f" ]; then
    echo "[WARN] $repo_f が存在しないため空ファイルを作成します"
    mkdir -p "$(dirname "$repo_f")"
    : > "$repo_f"   # 中身空のファイルを作成
  fi

  # 3. HOME 側を dotfiles/config のファイルへのシンボリックリンクに張り替える
  echo "[LINK] $home_f -> $repo_f"
  ln -sfn "$repo_f" "$home_f"
done

echo "------------------------------"

# 4. zsh 設定の再読み込み
if [ -n "${ZSH_VERSION:-}" ] && [ -f "$HOME/.zshrc" ]; then
  echo "[INFO] 現在 zsh を使用しているため ~/.zshrc を再読み込みします"
  # shellcheck disable=SC1090
  source "$HOME/.zshrc"
else
  echo "[INFO] 設定を反映するには新しい zsh ログインシェルを起動してください:"
  echo "       exec zsh -l"
fi

echo "[DONE] dotfiles のセットアップが完了しました"
