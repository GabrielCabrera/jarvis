# ==============================================================================
# COMPLETION SYSTEM & SUGGESTIONS (Performance Optimized)
# ==============================================================================

# Inject Homebrew completions early (Avoids calling slow $(brew --prefix) subshell)
if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
  FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
fi

# Native Completion Engine Initialization (Recompile dump file strictly once every 24 hours)
autoload -Uz compinit
_comp_path="${XDG_CACHE_HOME}/zsh/.zcompdump"

# Ensure cache directory structure exists natively
mkdir -p "$(dirname "$_comp_path")"

if [[ -n ${_comp_path}(#qN.mh+24) ]]; then
  compinit -C -d "$_comp_path" # Fast start, skip checking security permissions
else
  compinit -d "$_comp_path"
  { zcompile -R "$_comp_path" || zcompile "$_comp_path" } &>/dev/null &!
fi

# --- Advanced Zstyle Completion Tuning ---
zstyle ':completion:*' menu select # Use interactive menu selection with arrow keys on double tab
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # Case-insensitive fuzzy matching
zstyle ':completion:*' group-name '' # Categorize results (e.g., Commands, Files, Aliases)
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*' list-colors '' # Adhere to system terminal colors

# ==============================================================================
# EXTERNAL ASYNC PLUGINS (Homebrew Managed)
# ==============================================================================

# 1. Zsh Autosuggestions (Fish-like real-time inline predictions)
if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 2. Zsh Syntax Highlighting (Must be loaded strictly AFTER autosuggestions to prevent rendering conflicts)
if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ==============================================================================
# PROMPT
# ==============================================================================

# Initialize Starship prompt (Must be triggered last to capture sanitised environmental variables)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
