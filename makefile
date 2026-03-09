mac:bootstrap/mac_zsh.pm
	perl bootstrap/mac_zsh.pm

.PHONY: help setup mac

help:
	@echo "Available targets:"
	@echo "  make setup   # Setup zsh dotfiles on macOS"
	@echo "  make mac     # Alias of setup"
