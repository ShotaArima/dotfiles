setup: os

.PHONY: help setup mac uv-check
os:bootstrap/setup.pm
	perl bootstrap/setup.pm

mac: os
linux: os

.PHONY: help setup os mac linux

help:
	@echo "Available targets:"
	@echo "  make setup   # Setup dotfiles for current OS (macOS / Linux)"
	@echo "  make os      # Alias of setup"
	@echo "  make mac     # Alias of setup"
	@echo "  make uv-check # Check uv via Nix flake shell"

uv-check:
	@nix develop ./nix -c uv --version
	@echo "  make linux   # Alias of setup"
