mac:bootstrap/mac_zsh.pm
	perl bootstrap/mac_zsh.pm

.PHONY: help setup mac uv-check

help:
	@echo "Available targets:"
	@echo "  make setup   # Setup zsh dotfiles on macOS"
	@echo "  make mac     # Alias of setup"
	@echo "  make uv-check # Check uv via Nix flake shell"

uv-check:
	@nix develop ./nix -c uv --version
