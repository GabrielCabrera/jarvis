# Changelog

All notable changes to the `jarvis` Control Plane are documented in this file.

## [Initial Setup] - 2026-10-28

### Added
- **Core Architecture**: Initialized `~/Developer/jarvis` as the unified Control Plane (IaC) for developer environment management on macOS Apple Silicon.
- **Persistent Memory & Governance**:
  - Created `AGENTS.md` and synced to `.antigravity/rules.md` establishing agent contracts, persistent state enforcement, and strict safety guidelines.
  - Created `STATE.md` capturing the complete live inventory of Homebrew packages, runtime versions (`mise`), and Stow linkages.
- **Defense-in-Depth Security**:
  - Implemented `.gitignore` explicitly blocking sensitive directories, secrets, certificates (`.pem`, `.key`), Sealed Secrets manifests (`*sealed*.yaml`), private keys, and local session directories.
  - Implemented `.stow-local-ignore` inside `dotfiles/git/` to allow version-controlling the global `.gitignore` without GNU Stow default filtering.
- **Dotfiles Migration**:
  - Migrated clean configurations for `bat`, `btop`, `gh` (`config.yml`), `ghostty`, `git`, `glow`, `helm`, `homebrew`, `k9s`, `mise`, `nvim`, and `starship`.
  - Migrated `ruby` (`.gemrc`), `git` (`.gitconfig`, `.gitignore`), and `zsh` (`.zshrc`, `.zsh/`).
  - Migrated `Brewfile` to root of `jarvis`.
  - Migrated SSH allowlist (`config`, `allowed_signers`, and `ssh_hosts/*`).

### Changed
- **Architectural Refactoring (Decoupled Monoliths)**:
  - Replaced legacy monolithic symlink `~/.ssh -> ~/dotfiles/ssh/.ssh` with a real physical directory `~/.ssh` (`0700`).
  - Replaced legacy monolithic symlink `~/.config -> ~/dotfiles/config/.config` with a real physical directory `~/.config` (`0755`).
  - Switched symlink orchestration to `GNU Stow` with `--no-folding`.
  - Added `Include ~/.ssh/ssh_hosts/*` to `~/.ssh/config` for seamless host resolution.

### Security
- **Snapshot Phase 0**: Created full pre-migration snapshot in `~/Desktop/jarvis_pre_migration_backup_20261028_131122` (`chmod 700`) with tarball integrity verified (`TAR_INTEGRITY_CHECK=OK`).
- **Hardened Permissions**:
  - Enforced `0700` on `~/.ssh`, `~/.ssh/keys`, and `~/.ssh/deprecated_keys`.
  - Enforced `0600` on all private keys, `.pem`, `.key`, and `.yaml` files.
  - Enforced `0644` on public keys (`*.pub`) and `known_hosts*`.
  - Enforced `0600` on `~/.zsh_history`.
- **Secret Sanitization**:
  - Removed plain-text commented passwords from `dotfiles/ssh/.ssh/config` and host files in `ssh_hosts/` (`realtime_3ds_dev`, `realtime_shortener`).
  - Isolated SOPS Age master secret key (`~/.config/sops/age/keys.txt`) strictly to the local physical environment with `0600` permissions.
  - Isolated 1Password state (`1Password/`, `op/`), Wireshark state (`wireshark/`), and GitHub authentication credentials (`gh/hosts.yml`) strictly to the local physical filesystem.
