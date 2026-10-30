# ==============================================================================
# ZSH ARCHITECTURE | HOST: MACBOOK PRO M3
# ==============================================================================

# --- 1. PRE-FLIGHT CHECKS & PATHS ---

# Initialize Homebrew environment (Static paths for Apple Silicon to avoid subshell overhead)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# Essential Paths (Must be loaded before version managers)
export PATH="$HOME/.local/bin:$PATH"
if [[ -d "$HOME/.antigravity-ide/antigravity-ide/bin" ]]; then
  export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"
fi

# --- 2. CORE TOOLS INITIALIZATION ---

# MISE (Version Manager) - Standard activation for shim stability
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# --- 3. SHELL CONFIGURATION & HISTORY ---

# Store history locally on local SSD to avoid iCloud sync loops, lockups and lag
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000               # 100k history depth is highly performant in Apple Silicon RAM
SAVEHIST=100000

# Advanced History Settings
setopt INC_APPEND_HISTORY_TIME # Write immediately upon command termination, avoid sifting reads
setopt SHARE_HISTORY           # Sincroniza el historial entre múltiples pestañas/sesiones en vivo
setopt HIST_IGNORE_ALL_DUPS    # Deduplicate aggressively, keeps only the latest unique command
setopt HIST_SAVE_NO_DUPS       # Asegura que al escribir en disco, jamás se guarde un duplicado
setopt HIST_FIND_NO_DUPS       # Oculta duplicados mientras buscas hacia arriba (Arrow Up)
setopt HIST_EXPIRE_DUPS_FIRST  # Trim duplicates first when history cap is reached
setopt HIST_IGNORE_SPACE       # Omit logging commands prefixed with a space (security guard)
setopt HIST_VERIFY             # Validate history expansions (!$) before immediate execution
setopt HIST_REDUCE_BLANKS      # Limpia los espacios en blanco excesivos antes de guardar
setopt HIST_LEX_WORDS          # Discard redundant inline whitespace formatting

# Define native Zsh history filtering patterns
setopt EXTENDED_GLOB
HISTORY_IGNORE="(ls(| *)|cd(| *)|pwd|exit|logout|clear|la(| *)|ll(| *)|c|history|upall|rm_DStore|bat(| *)|cat(| *)|tldr(| *)|man(| *)|ping(| *)|dig(| *)|eza(| *)|tree(| *)|mkdir(| *))"

# History searching via Up and Down arrow keys (Filters history matching the written prefix)
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# --- 4. MODULE LOADER ---

# Load all modular configuration files from the .zsh directory
if [[ -d "$HOME/.zsh" ]]; then
  for config_file in "$HOME/.zsh/"*.zsh; do
    source "$config_file"
  done
fi

# Load Private Secrets & API Keys (Strictly local, ignored by git)
if [[ -f "$HOME/.zsh_secrets" ]]; then
  source "$HOME/.zsh_secrets"
fi
