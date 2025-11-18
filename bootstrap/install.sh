#!/usr/bin/env bash
set -eu # 環境の設定

DOTFILES="${DOTFILES:-$HOME/dotfiles}"   # 環境変数から上書きできる
BOOTSTRAP_DIR="$DOTFILES/bootstrap"

. "$BOOTSTRAP_DIR/detect_os.sh"
OS="$(detect_os)"
echo "[INFO] Detected OS: $OS"

if [ "$OS" != "mac" ]; then
  echo "[INFO] macOS ではないため、この install.sh では何もしません。"
  echo "       OSごとの install スクリプトを分けるか、処理を追記してください。"
  exit 0
fi


link() {
  src="$1" # 1番目の引数
  dst="$2" # 2番目の引数
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then # 実体が存在する場合
    echo "[WARN] $dst が既に存在します (バックアップを推奨)"
    mv "$dst" "${dst}.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  ln -snf "$src" "$dst"
}

case "$OS" in
  mac)
    echo "[INFO] Setting up for macOS..."
    # zshrc, bashrc, gitconfig 等を貼る
    link "$DOTFILES/bootstrap/stub.zshrc" "$HOME/.zshrc"
    link "$DOTFILES/bootstrap/stub.bashrc" "$HOME/.bashrc"
    link "$DOTFILES/config/gitconfig"     "$HOME/.gitconfig"

    # ~/bin を PATH に入れる前提で link
    mkdir -p "$HOME/bin"
    link "$DOTFILES/bin" "$HOME/bin/dotfiles-bin"
    
    ;;
  *)
    echo "[ERROR] Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "Done. シェルを再起動してください。"