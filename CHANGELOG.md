# Changelog

All notable changes to the `jarvis` Control Plane are documented in this file.

## [Unreleased] - 2026-10-29

### Changed
- **SSH Host Collision Resolution (`realtime_soa_prod`)**:
  - Prefixed internal cluster host definitions in `dotfiles/ssh/.ssh/ssh_hosts/realtime_soa_prod` with `soa-prod-*` (`soa-prod-nginx-plus`, `soa-prod-core-01`, `soa-prod-io-worker`, etc.).
  - Restored primary `nginx-plus` resolution directly to public Azure host `20.124.177.51` (`azureuser`, `nginx_plus_standard_key.pem`, no ProxyJump).
  - Eliminated namespace collisions with active servers in `~/.ssh/config` caused by top-level inclusion.
- **Antigravity Terminal Title Formatting**:
  - Adjusted Ghostty tab title badge spacing to `[ <project> | <mode> ]` (e.g., `[ jarvis | STD ]`) for improved readability.
- **Antigravity Statusline Quota Telemetry**:
  - Implemented dynamic model provider routing (`gemini` vs `3p`) in `statusline.sh` to prevent inactive 3P buckets from masking Gemini consumption.
  - Replaced single static quota indicator with dual-horizon observability: immediate operational burst window (`🔋 XX% (5h)`) and weekly budget window (`📅 YY% (sem)`).
  - Added dynamic battery icon transitioning between full (`🔋`) and critical/low battery (`🪫` at <= 20%).
  - Added color-coded urgency thresholds (Yellow/Red) for quota degradation.
  - Added safe fallback variable initialization before `eval` to prevent shell unbound variable crashes on empty or partial JSON payloads.

## [Unreleased] - 2026-10-28

### Added
- **Antigravity CLI Optimization (`gemini` Stow package)**:
  - Created `dotfiles/gemini/.gemini/antigravity-cli/title.sh` with single-pass `jq` parsing and `tool_confirmation_pending` alerts for Ghostty tab titles.
  - Created `dotfiles/gemini/.gemini/antigravity-cli/statusline.sh` with single `jq` invocation (`@sh` safe eval), 10-segment visual context bar, and Git branch caching (5s TTL in `/tmp`).
  - Versioned audited `settings.json` configuring `statusLine` and `title` without sensitive data or tokens.
  - Added `jq` formula (v1.8.2) to `Brewfile`.
  - Updated `scripts/stow.sh` and `AGENTS.md` to include `gemini` in the managed stow packages.
  - Added defensive `.gitignore` rules for `~/.gemini/` brain state, conversation logs, and credential patterns.

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
