#!/usr/bin/env bash
# ==============================================================================
# Jarvis Control Plane - Stow Symlink Orchestrator
# Applies GNU Stow packages to $HOME using --no-folding
# ==============================================================================
set -euo pipefail

JARVIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$JARVIS_DIR/dotfiles"
TARGET_DIR="$HOME"

# Managed package list
PACKAGES=("config" "git" "ruby" "ssh" "zsh")

echo "==> Applying GNU Stow packages from $DOTFILES_DIR to $TARGET_DIR..."
stow -d "$DOTFILES_DIR" -t "$TARGET_DIR" --no-folding "${PACKAGES[@]}"

echo "==> All dotfile packages successfully linked."
