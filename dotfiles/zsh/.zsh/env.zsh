# ==============================================================================
# PUBLIC ENVIRONMENT VARIABLES & PATHS
# ==============================================================================
# Managed via jarvis control plane
# General environment variables, language flags, and toolchain optimizations.

export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ==============================================================================
# RUNTIME OPTIMIZATIONS (Toolchains)
# ==============================================================================

# Ruby: Aggressive optimization for Apple Silicon
export RUBY_CONFIGURE_OPTS="--with-jemalloc --enable-yjit"
export RUBY_YJIT_ENABLE="1"
export BUNDLE_JOBS="8"
export BUNDLE_RETRY="3"

# Python: Cleanliness
export PYTHONDONTWRITEBYTECODE="1" # Prevent __pycache__ spam in project roots

# Node/NPM: XDG Compliance (Clean $HOME)
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
