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
PACKAGES=("config" "gemini" "git" "ruby" "ssh" "zsh")

# Auto-reconcile files decoupled by application atomic writes (e.g. agy settings updates)
AGY_SETTINGS="$TARGET_DIR/.gemini/antigravity-cli/settings.json"
REPO_SETTINGS="$DOTFILES_DIR/gemini/.gemini/antigravity-cli/settings.json"
if [[ -f "$AGY_SETTINGS" && ! -L "$AGY_SETTINGS" ]]; then
  echo "==> Reconciling $AGY_SETTINGS (decoupled by CLI atomic write)..."
  cp "$AGY_SETTINGS" "$REPO_SETTINGS"
  rm "$AGY_SETTINGS"
fi

echo "==> Applying GNU Stow packages from $DOTFILES_DIR to $TARGET_DIR..."
stow -d "$DOTFILES_DIR" -t "$TARGET_DIR" --no-folding "${PACKAGES[@]}"

echo "==> All dotfile packages successfully linked."
