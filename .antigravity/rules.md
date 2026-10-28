# Jarvis Control Plane - Agent Operating Directives

## 1. System Purpose & Architecture
`jarvis` functions as the single Infrastructure as Code (IaC) Control Plane for managing the development environment on this macOS machine (Apple Silicon).
- **Scope**: Developer environment, tooling, CLI configurations, shell environment, and runtime versions.
- **Explicit Boundary**: Do **NOT** modify macOS native system preferences via `defaults write` or system-level configuration files unless explicitly instructed by the user.

## 2. Managed Technology Stack
- **Package Management**: Homebrew declarative bundle via `~/Developer/jarvis/Brewfile`.
- **Runtime & Language Tooling**: `mise` (`~/.config/mise/config.toml`).
- **Symlink Management**: `GNU Stow`. Always use `--no-folding` flag to prevent directory folding into monolithic symlinks (`stow -d ~/Developer/jarvis/dotfiles -t ~ --no-folding <packages>`). Managed packages: `config`, `gemini`, `git`, `ruby`, `ssh`, `zsh`.
- **AI Tooling & CLI**: Antigravity CLI (`gemini` package in `dotfiles/gemini/.gemini/antigravity-cli/`: `statusline.sh`, `title.sh`, and audited `settings.json`).
- **Shell & Terminal**: `Zsh` (`~/.zshrc`, `~/.zsh/`), `Ghostty`, `Starship` prompt.
- **Editor**: `Neovim` (`~/.config/nvim/`).
- **VCS**: `Git` (`~/.gitconfig`, `~/.gitignore`).
- **SSH Configuration**: Managed via strict allowlist in `dotfiles/ssh/.ssh/`:
  - Versioned: `config`, `allowed_signers`, and `ssh_hosts/*`.
  - Strictly **NEVER** versioned: `keys/`, `deprecated_keys/`, `known_hosts*`, root private/public keys, certificates (`.pem`, `.key`), or Kubernetes sealed secret backups.

## 3. Persistent Memory & State Contract (Golden Rules)
No future task or user request is considered complete without updating:
1. **`STATE.md`**: The live inventory of the system (active packages in Brewfile, runtimes via `mise ls`, stow packages, symlink targets, active status).
2. **`CHANGELOG.md`**: Chronological record detailing timestamp, affected component, change summary, and rationale.

## 4. Scripts Policy
- **Ephemeral/Migration Scripts**: Must reside exclusively in `~/Developer/jarvis/tmp/` and must be deleted before concluding the task.
- **Permanent Operational Scripts**: Reside in `~/Developer/jarvis/scripts/` or `~/Developer/jarvis/bin/`.
- **Script Standards**:
  - Shebang: `#!/usr/bin/env bash`
  - Strict mode: `set -euo pipefail`
  - Idempotency: Running the script multiple times produces the exact same desired state without duplicate side-effects.
  - Language: All code comments and documentation in English.

## 5. Security & Isolation Directives
- **Physical vs Symlinked directories**:
  - `~/.ssh`, `~/.config`, and `~/.gemini` must ALWAYS remain real physical directories in `$HOME`. Never turn them into monolithic symlinks.
  - Local state and credentials (e.g., `~/.config/1Password/`, `~/.config/op/`, `~/.config/wireshark/`, `~/.config/gh/hosts.yml`, `~/.gemini/antigravity/brain/`, session DBs, and logs) remain local physical files/directories and are never committed.
  - Shell history (`~/.zsh_history`) is a local physical file with permissions `0600`.
- **Communication Style**:
  - Respond to the user in Spanish, direct and technical.
  - Code, commit messages, and documentation in English.
