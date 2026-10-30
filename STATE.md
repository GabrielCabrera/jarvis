# Jarvis Control Plane - System State & Inventory

**Last Updated:** 2026-10-28
**Host Architecture:** MacBook Pro (Apple M3 Pro, 18 GB Unified Memory, macOS)
**Control Plane Root:** `~/Developer/jarvis`
**Git Remote:** `git@github.com:GabrielCabrera/jarvis.git`

---

## 1. Tooling & Runtimes Inventory

### Package Management: Homebrew (`~/Developer/jarvis/Brewfile`)
- **CLI Utilities & Infrastructure:** `age`, `ansible`, `awscli`, `azure-cli`, `bat`, `btop`, `colima`, `docker`, `docker-compose`, `eza`, `fzf`, `gh`, `git`, `glow`, `helm`, `jemalloc`, `jq`, `k9s`, `kubernetes-cli`, `kubeseal`, `tree-sitter`, `neovim`, `pandoc`, `protobuf`, `pwgen`, `restic`, `ripgrep`, `sops`, `sqlcmd`, `starship`, `stow`, `tlrc`, `tree-sitter-cli`, `wireshark`, `zsh-autosuggestions`, `zsh-syntax-highlighting` (33 formulas).
- **Casks:** `1password-cli`, `font-jetbrains-mono-nerd-font` (2 casks).
- **Node Tools:** None (purged unneeded corepack).

### Runtime & Language Tooling (`mise`)
Configuration source: `~/.config/mise/config.toml` (managed via `jarvis/dotfiles/config/.config/mise/config.toml`)
Active versions:
- `go`: 1.27.3 (Latest stable)
- `python`: 3.15.2 (Latest stable)
- `ruby`: 4.0.9 (Latest stable)
- `usage`: 7.1.3 (Latest stable)
- `uv`: 0.13.6 (Latest stable)

---

## 2. GNU Stow Packages & Target Resolution

Stow command standard:
`stow -d ~/Developer/jarvis/dotfiles -t ~ --no-folding <packages>`

| Package | Versioned Source Path | Target Link in `$HOME` | Folding Mode |
| :--- | :--- | :--- | :--- |
| `config` | `dotfiles/config/.config/bat/` | `~/.config/bat/config` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/btop/` | `~/.config/btop/btop.conf` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/gh/config.yml` | `~/.config/gh/config.yml` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/ghostty/` | `~/.config/ghostty/config` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/git/` | `~/.config/git/allowed_signers` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/glow/` | `~/.config/glow/glow.yml` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/helm/` | `~/.config/helm/repositories.*` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/homebrew/` | `~/.config/homebrew/trust.json.lock` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/k9s/` | `~/.config/k9s/*` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/mise/` | `~/.config/mise/config.toml` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/nvim/` | `~/.config/nvim/` | Unfolded (`--no-folding`) |
| `config` | `dotfiles/config/.config/starship/` | `~/.config/starship/starship.toml` | Unfolded (`--no-folding`) |
| `gemini` | `dotfiles/gemini/.gemini/antigravity-cli/settings.json` | `~/.gemini/antigravity-cli/settings.json` | Unfolded (`--no-folding`) |
| `gemini` | `dotfiles/gemini/.gemini/antigravity-cli/statusline.sh` | `~/.gemini/antigravity-cli/statusline.sh` | Unfolded (`--no-folding`) |
| `gemini` | `dotfiles/gemini/.gemini/antigravity-cli/title.sh` | `~/.gemini/antigravity-cli/title.sh` | Unfolded (`--no-folding`) |
| `git` | `dotfiles/git/.gitconfig` | `~/.gitconfig` | Direct link |
| `git` | `dotfiles/git/.gitignore` | `~/.gitignore` | Direct link (`.stow-local-ignore`) |
| `ruby` | `dotfiles/ruby/.gemrc` | `~/.gemrc` | Direct link |
| `ssh` | `dotfiles/ssh/.ssh/allowed_signers` | `~/.ssh/allowed_signers` | Unfolded (`--no-folding`) |
| `ssh` | `dotfiles/ssh/.ssh/config` | `~/.ssh/config` | Unfolded (`--no-folding`) |
| `ssh` | `dotfiles/ssh/.ssh/ssh_hosts/*` | `~/.ssh/ssh_hosts/*` | Unfolded (`--no-folding`) |
| `zsh` | `dotfiles/zsh/.zshrc` | `~/.zshrc` | Direct link |
| `zsh` | `dotfiles/zsh/.zsh/*.zsh` | `~/.zsh/*.zsh` | Unfolded (`--no-folding`) |

---

## 3. Physical Isolated Assets (Strictly Local / Non-Versioned)

The following assets reside purely as physical files/directories on disk and are blocked from git tracking:
- **`~/.ssh/` (Real physical directory, `0700`):**
  - Private root keys (`id_ed25519`, `homelab_ed25519`, `argocd_github_key` with permissions `0600`).
  - Public root keys (`*.pub` with permissions `0644`).
  - Known hosts (`known_hosts`, `known_hosts.old` with permissions `0644`).
  - `keys/` directory (`0700`): 48 keys, certificates (`.pem`, `.key`), and Kubernetes sealed secret backups (`0600`).
  - `deprecated_keys/` directory (`0700`): 35 legacy private keys and certs (`0600`).
- **`~/.config/` (Real physical directory, `0755`):**
  - `1Password/` (Local credentials and telemetry flags).
  - `op/` (1Password CLI config and socket runtime).
  - `wireshark/` (Profiles and runtime history).
  - `gh/hosts.yml` (Local GitHub authentication credentials).
  - `sops/age/keys.txt` (Local Age master secret key for SOPS decryption, permissions `0600`).
- **`~/.zsh_history` (Physical file, `0600`):**
  - Zsh command history preserved locally.
- **`~/.gemini/` (Real physical directory):**
  - Antigravity sessions, brain memory (`brain/`), conversation logs, conversation summaries databases (`*.db*`), and history (`history.jsonl`) remain strictly local and unversioned.

---

## 4. Verification Check Status
- `ssh -G github.com`: OK (Resolves `ssh.github.com:443`, `user git`).
- `ssh -G shortener`: OK (Resolves host in `ssh_hosts/realtime_shortener`).
- `git config --list`: OK (Resolves commit GPG/SSH signing via 1Password and `allowed_signers`).
- `mise ls`: OK (All runtimes active: go 1.27, python 3.15, ruby 4.0, uv 0.13, usage 7.1).
- `go version`: OK (go1.27.3 darwin/arm64).
- `uv --version`: OK (v0.13.6).
- `starship --version`: OK (v1.27.0).
- `zsh -n ~/.zshrc`: OK (Syntax valid across all 4 modules: env, functions, aliases, plugins).
- `zcompdump`: OK (Recompiled and compiled to `.zwc` bytecode).
- `title.sh` & `statusline.sh`: OK (Tested dry-run with stdin JSON, exit code 0).
- `settings.json`: OK (Symlink verified pointing to `dotfiles/gemini/.../settings.json`, auto-reconcile in `scripts/stow.sh`).
- Legacy directory: `~/dotfiles.bak_pre_jarvis` preserved.
