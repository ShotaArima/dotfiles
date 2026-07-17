# WezTerm 開発ディレクトリ用のショートカット makefile。
# ~/.config/wezterm は dotfiles リポジトリへのシンボリックリンクなので、
# このファイル自身の実体パスを realpath で解決し、dotfiles ルートの makefile へ委譲する。
# これで開発中に ~/.config/wezterm 内からでも `make wezterm` を実行できる。

MKFILE_DIR    := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
DOTFILES_ROOT := $(realpath $(MKFILE_DIR)/../..)

.PHONY: wezterm setup help

wezterm setup:
	$(MAKE) -C $(DOTFILES_ROOT) $@

help:
	@echo "Shortcut to dotfiles root makefile ($(DOTFILES_ROOT))"
	@echo "  make wezterm  # Link WezTerm config (~/.config/wezterm)"
	@echo "  make setup    # Full dotfiles setup"
