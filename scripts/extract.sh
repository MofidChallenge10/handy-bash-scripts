#!/usr/bin/env bash
# extract - unpack almost any common archive with one command.
# Usage: extract <archive> [destination_dir]
set -euo pipefail

if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  echo "Usage: extract <archive> [destination_dir]"
  echo "Supports: tar.gz tgz tar.bz2 tar.xz tar.zst tar zip 7z rar gz bz2 xz"
  exit 1
fi

file="$1"
dest="${2:-.}"

[[ -f "$file" ]] || { echo "Error: '$file' is not a file" >&2; exit 1; }
mkdir -p "$dest"

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "Error: '$1' is required but not installed" >&2; exit 1; }
}

lower=$(printf '%s' "$file" | tr '[:upper:]' '[:lower:]')
base=$(basename "${file%.*}")

case "$lower" in
  *.tar.gz|*.tgz)   need tar;    tar -xzf "$file" -C "$dest" ;;
  *.tar.bz2|*.tbz2) need tar;    tar -xjf "$file" -C "$dest" ;;
  *.tar.xz|*.txz)   need tar;    tar -xJf "$file" -C "$dest" ;;
  *.tar.zst)        need tar;    tar --zstd -xf "$file" -C "$dest" ;;
  *.tar)            need tar;    tar -xf "$file" -C "$dest" ;;
  *.zip)            need unzip;  unzip -q "$file" -d "$dest" ;;
  *.7z)             need 7z;     7z x -y "-o$dest" "$file" >/dev/null ;;
  *.rar)            need unrar;  unrar x -idq "$file" "$dest/" ;;
  *.gz)             need gunzip; gunzip -c "$file" > "$dest/$base" ;;
  *.bz2)            need bunzip2; bunzip2 -c "$file" > "$dest/$base" ;;
  *.xz)             need unxz;   unxz -c "$file" > "$dest/$base" ;;
  *) echo "Error: unsupported archive format: $file" >&2; exit 1 ;;
esac

echo "Extracted '$file' -> '$dest'"
