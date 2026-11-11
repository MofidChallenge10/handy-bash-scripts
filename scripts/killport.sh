#!/usr/bin/env bash
# killport - stop whatever process is listening on a TCP port.
# Usage: killport <port> [-f]      (-f sends SIGKILL instead of SIGTERM)
set -euo pipefail

port="${1:-}"
sig="TERM"
[[ "${2:-}" == "-f" ]] && sig="KILL"

if [[ -z "$port" || ! "$port" =~ ^[0-9]+$ ]]; then
  echo "Usage: killport <port> [-f]" >&2
  exit 1
fi

if command -v lsof >/dev/null 2>&1; then
  pids=$(lsof -t -iTCP:"$port" -sTCP:LISTEN 2>/dev/null || true)
elif command -v ss >/dev/null 2>&1; then
  pids=$(ss -ltnp "sport = :$port" 2>/dev/null | grep -o 'pid=[0-9]*' | cut -d= -f2 | sort -u || true)
else
  echo "Error: either 'lsof' or 'ss' is required" >&2
  exit 1
fi

if [[ -z "$pids" ]]; then
  echo "Nothing is listening on port $port"
  exit 0
fi

for pid in $pids; do
  name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "?")
  echo "Stopping $name (pid $pid) with SIG$sig"
  kill -"$sig" "$pid"
done
