#!/usr/bin/env bash
# backup - create a timestamped .tar.gz of a directory and keep only the newest N.
# Usage: backup <source_dir> [dest_dir=~/backups] [keep=5]
set -euo pipefail

src="${1:-}"
dest="${2:-$HOME/backups}"
keep="${3:-5}"

if [[ -z "$src" || ! -d "$src" ]]; then
  echo "Usage: backup <source_dir> [dest_dir=~/backups] [keep=5]" >&2
  exit 1
fi
if [[ ! "$keep" =~ ^[0-9]+$ || "$keep" -lt 1 ]]; then
  echo "Error: 'keep' must be a positive integer" >&2
  exit 1
fi

abs_src=$(cd "$src" && pwd)
name=$(basename "$abs_src")
parent=$(dirname "$abs_src")

mkdir -p "$dest"
stamp=$(date +%Y%m%d-%H%M%S)
out="$dest/${name}-${stamp}.tar.gz"

tar -czf "$out" -C "$parent" "$name"
echo "Created $out ($(du -h "$out" | cut -f1))"

# Rotation: delete everything except the newest $keep backups of this directory.
ls -1t "$dest/${name}-"*.tar.gz 2>/dev/null | tail -n +"$((keep + 1))" | while read -r old; do
  echo "Removing old backup: $old"
  rm -f -- "$old"
done
