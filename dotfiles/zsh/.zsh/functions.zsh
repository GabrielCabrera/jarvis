# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Fix: Custom "Soft Clear" function. Forces viewport displacement into Ghostty's 
# scrollback buffer by printing $LINES newlines, then resets the cursor position to Home.
soft_clear() {
  local lines=${LINES:-$(tput lines 2>/dev/null || echo 40)}
  printf '\n%.0s' {1..$lines}
  printf '\e[H'
}

# Create directory and enter it seamlessly
mkcd() { 
  mkdir -p "$1" && cd "$1"
}

# Generate passwords on demand and copy them cleanly to the Apple Clipboard
genpass() {
  if command -v pwgen &> /dev/null; then
    pwgen --secure "$@" 1 | tr -d '\n' | pbcopy
    echo "Password copiado al portapapeles."
  else
    echo "Error: pwgen no está instalado. Ejecuta 'brew install pwgen'"
  fi
}

# Gitignore generator (Official Toptal Implementation)
function gi() {
  curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@
}

# The "Oops" Panic Button (Removes the last executed line from memory and disk history to fix typos)
oops() {
  if [[ -f "$HISTFILE" ]]; then
    local last_cmd=$(tail -n 1 "$HISTFILE")
    # Native support for macOS/Darwin sed inline deletion vs GNU Linux sed compatibility
    sed -i '' '$d' "$HISTFILE" 2>/dev/null || sed -i '$d' "$HISTFILE"
    # Force reload of the clean history file into the active terminal instance
    fc -R "$HISTFILE"
    echo "• Removido del historial: '$last_cmd'"
  else
    echo "Error: No se encontró el archivo de historial."
  fi
}

# Universal Update Tool (SRE Optimized)
upall() {
    echo ""
    echo "🍺 Actualizando Homebrew..."
    brew update && brew upgrade && brew cleanup
    
    echo ""
    echo "🛠️ Actualizando Mise y sus herramientas..."
    mise self-update -y && mise upgrade
    
    if command -v gem &> /dev/null; then
      echo ""
      echo "💎 Actualizando Ruby Gems..."
      gem update --system && gem update && gem cleanup
    fi
    
    if command -v uv &> /dev/null; then
      echo ""
      echo "🐍 Actualizando herramientas de Python (uv)..."
      uv tool upgrade --all 2>/dev/null || true
    fi
    
    if command -v npm &> /dev/null; then
      echo ""
      echo "📦 Actualizando NPM Global..."
      npm update -g
    fi
    
    echo ""
    echo "🤖 Actualizando Agentes IA..."
    if command -v agy &> /dev/null; then
      agy update 2>/dev/null || true
    fi
    if command -v claude &> /dev/null; then
      claude update 2>/dev/null || true
    fi
    
    echo ""
    echo "✅ ¡Todo el sistema está actualizado!"
    echo ""
}

# Inicia la máquina virtual de Colima con parámetros ultra-optimizados para Apple Silicon (M-series)
docker_up() {
  echo "🚀 Iniciando el motor de Docker (Colima)..."
  # Optimizaciones: VZ Framework nativo, Rosetta para x86_64, VirtioFS para I/O rápido
  colima start --cpu 4 --memory 6 --disk 50 --vm-type=vz --vz-rosetta --mount-type=virtiofs
}

# Apaga la máquina virtual de Colima para liberar RAM y batería
docker_down() {
  echo "🛑 Apagando el motor de Docker..."
  colima stop
}
