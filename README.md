# Jarvis Control Plane

Unified Infrastructure as Code (IaC) and Developer Environment management for macOS (Apple Silicon).

## Architecture & Governance

`jarvis` manages the local developer environment, tools, runtime environments, and configuration files declaratively and reproducibly:

- **Package Management:** Homebrew declarative stack via [`Brewfile`](file:///Users/gabriel/Developer/jarvis/Brewfile).
- **Runtimes & Toolchains:** Managed via [`mise`](file:///Users/gabriel/Developer/jarvis/dotfiles/config/.config/mise/config.toml) (`~/.config/mise/config.toml`).
- **Symlink Management:** Orchestrated via `GNU Stow` with `--no-folding` (`scripts/stow.sh`).
- **Strict SSH Allowlist:** Only `config`, `allowed_signers`, and `ssh_hosts/*` are versioned. All private keys and host keys are isolated locally in `$HOME/.ssh/`.
- **System Memory:** [`STATE.md`](file:///Users/gabriel/Developer/jarvis/STATE.md) (live inventory) and [`CHANGELOG.md`](file:///Users/gabriel/Developer/jarvis/CHANGELOG.md) (chronological record).
- **Agent Operating Directives:** Documented in [`AGENTS.md`](file:///Users/gabriel/Developer/jarvis/AGENTS.md).

## Directory Structure

```text
~/Developer/jarvis/
├── AGENTS.md            # Agent operating directives & architectural rules
├── Brewfile             # Declarative Homebrew package inventory
├── CHANGELOG.md         # Chronological log of changes
├── STATE.md             # Live state and system inventory
├── bin/                 # Local helper binaries
├── dotfiles/            # Managed Stow packages
│   ├── config/          # ~/.config applications (bat, btop, gh, ghostty, etc.)
│   ├── gemini/          # ~/.gemini/antigravity-cli (statusline.sh, title.sh, settings.json)
│   ├── git/             # ~/.gitconfig and ~/.gitignore
│   ├── ruby/            # ~/.gemrc
│   ├── ssh/             # ~/.ssh/config, allowed_signers, ssh_hosts/
│   └── zsh/             # ~/.zshrc and ~/.zsh/ modules
├── scripts/             # Operational automation scripts (idempotent)
└── tmp/                 # Ephemeral working scripts (gitignored)
```

## Quick Start

### Applying Symlinks
```bash
./scripts/stow.sh
```

### Checking Status
```bash
git status
ssh -G github.com
mise ls
```
