#!/usr/bin/env bash
# install.sh — provision a ~/.scripts/bin directory and put it on your PATH.
#
# This repo is a SETUP/template, not a script collection. Running this creates
# a separate ~/.scripts/bin where YOUR own scripts live (kept private/local),
# and wires it onto your PATH so they run from anywhere.
set -euo pipefail

SCRIPTS_DIR="${SCRIPTS_DIR:-$HOME/.scripts}"
BIN_DIR="$SCRIPTS_DIR/bin"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$BIN_DIR"
echo "✓ ensured $BIN_DIR"

# Pick the right shell rc file
case "${SHELL##*/}" in
  zsh)  RC="$HOME/.zshrc" ;;
  bash) RC="$HOME/.bashrc" ;;
  *)    RC="$HOME/.profile" ;;
esac

MARKER="# agent-scripts: add ~/.scripts/bin to PATH"
if grep -qF "$MARKER" "$RC" 2>/dev/null; then
  echo "✓ PATH entry already present in $RC"
else
  {
    echo ""
    echo "$MARKER"
    echo 'export PATH="$HOME/.scripts/bin:$PATH"'
  } >> "$RC"
  echo "✓ added ~/.scripts/bin to PATH in $RC"
fi

# Offer the example(s) as a starting point (copied, never symlinked to the repo)
if [ -d "$REPO_DIR/examples" ]; then
  for ex in "$REPO_DIR"/examples/*; do
    [ -f "$ex" ] || continue
    name="$(basename "$ex")"
    if [ -e "$BIN_DIR/$name" ]; then
      echo "• skipped example '$name' (already exists in $BIN_DIR)"
    else
      cp "$ex" "$BIN_DIR/$name" && chmod +x "$BIN_DIR/$name"
      echo "• installed example '$name' -> $BIN_DIR/$name"
    fi
  done
fi

echo ""
echo "Done. Open a new shell (or: source $RC), then drop scripts into:"
echo "  $BIN_DIR"
echo "They'll be runnable by name from anywhere."
