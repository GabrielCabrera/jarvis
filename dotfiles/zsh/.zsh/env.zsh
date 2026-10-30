# ==============================================================================
# ENVIRONMENT VARIABLES & TOOLCHAIN OPTIMIZATIONS
# ==============================================================================
# Managed via jarvis control plane

# --- 1. XDG Base Directory Specification ---
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# --- 2. Default System Utilities ---
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# --- 3. Runtime & Toolchain Optimizations ---
# Ruby: Aggressive optimization for Apple Silicon
export RUBY_CONFIGURE_OPTS="--with-jemalloc --enable-yjit"
export RUBY_YJIT_ENABLE="1"
export BUNDLE_JOBS="8"
export BUNDLE_RETRY="3"

# Python: Cleanliness
export PYTHONDONTWRITEBYTECODE="1" # Prevent __pycache__ spam in project roots
