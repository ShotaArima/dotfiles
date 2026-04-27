# ~/.zprofile

# --- 1) システム標準 PATH を確保（既存 PATH を保持）
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin${PATH:+:$PATH}"

# --- 2) Homebrew（Apple Silicon）
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- 3) MATLAB 追加
if [ -d "/Applications/MATLAB_R2025b.app/bin" ]; then
  export PATH="$PATH:/Applications/MATLAB_R2025b.app/bin"
fi

# --- 4) Nix（インストール済みなら有効化）
# Nix を使って `nix profile install nixpkgs#uv` で uv を導入できるようにする
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Nix profile 配下のコマンドを優先的に参照
if [ -d "$HOME/.nix-profile/bin" ]; then
  export PATH="$HOME/.nix-profile/bin:$PATH"
fi


