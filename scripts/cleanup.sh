#!/usr/bin/env bash
# cleanup - reclaim disk space by emptying common user-level caches.
# Dry-run by default: it only reports what it WOULD delete.
# Usage: cleanup [--yes]
set -uo pipefail

apply=false
case "${1:-}" in
  --yes|-y) apply=true ;;
  "") ;;
  *) echo "Usage: cleanup [--yes]" >&2; exit 1 ;;
esac

targets=(
  "$HOME/.cache/thumbnails"
  "$HOME/.npm/_cacache"
  "$HOME/.cache/pip"
  "$HOME/.local/share/Trash/files"
)

total_kb=0
for dir in "${targets[@]}"; do
  [[ -d "$dir" ]] || continue
  size_kb=$(du -sk "$dir" 2>/dev/null | cut -f1)
  total_kb=$((total_kb + size_kb))
  printf '%-45s %8s KB\n' "$dir" "$size_kb"
  if $apply; then
    find "$dir" -mindepth 1 -delete 2>/dev/null
  fi
done

echo "----"
if $apply; then
  echo "Freed about $((total_kb / 1024)) MB"
else
  echo "Could free about $((total_kb / 1024)) MB. Re-run with --yes to delete."
fi
