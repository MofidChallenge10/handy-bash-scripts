#!/usr/bin/env bash
# install - symlink every script in ./scripts into a bin directory (default: ~/.local/bin)
# Usage: bash install.sh [target_dir]
set -euo pipefail

src="$(cd "$(dirname "$0")" && pwd)/scripts"
dest="${1:-$HOME/.local/bin}"

mkdir -p "$dest"

for f in "$src"/*.sh; do
  name=$(basename "$f" .sh)
  chmod +x "$f"
  ln -sf "$f" "$dest/$name"
  echo "Installed: $name -> $dest/$name"
done

case ":$PATH:" in
  *":$dest:"*) ;;
  *) echo
     echo "Note: $dest is not in your PATH. Add this line to ~/.bashrc or ~/.zshrc:"
     echo "  export PATH=\"$dest:\$PATH\"" ;;
esac
