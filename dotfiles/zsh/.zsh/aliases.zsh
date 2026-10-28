# ==============================================================================
# ALIASES
# ==============================================================================

# Modern Replacements (Rust utilities)
if command -v eza &> /dev/null; then
  alias l='eza --group-directories-first --ignore-glob=".git|.DS_Store"'
  alias ll='eza --group-directories-first -l'
  alias la='eza --group-directories-first -la --git --ignore-glob=".DS_Store"'
  alias tree='eza --tree'
fi

# Shell administration utilities
alias reload="source $HOME/.zshrc"
alias c="soft_clear"
alias rm_DStore='find . -type f -name ".DS_Store" -delete' # Native cleanup execution, avoids exec rm loops

# Docker / Colima On-Demand
alias dup="docker_up"
alias ddown="docker_down"
