#!/usr/bin/env bash
# sysinfo - quick system overview (Linux and macOS).
# Usage: sysinfo
set -uo pipefail

os=$(uname -s)

echo "== System =="
echo "Host     : $(hostname)"
echo "OS       : $(uname -sr)"
echo "Uptime   : $(uptime | sed 's/^.*up *//; s/, *[0-9]* user.*//')"

echo
echo "== CPU =="
if [[ "$os" == "Darwin" ]]; then
  echo "Model    : $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo n/a)"
  echo "Cores    : $(sysctl -n hw.ncpu)"
else
  echo "Model    : $(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2- | sed 's/^ //')"
  echo "Cores    : $(nproc 2>/dev/null || echo n/a)"
fi
echo "Load     : $(uptime | awk -F'load averages?: ' '{print $2}')"

echo
echo "== Memory =="
if [[ "$os" == "Darwin" ]]; then
  echo "Total    : $(( $(sysctl -n hw.memsize) / 1024 / 1024 )) MB"
else
  free -h | awk 'NR==1 || /^Mem:/'
fi

echo
echo "== Disk (/) =="
df -h / | awk 'NR==1 || NR==2'

echo
echo "== Network =="
if [[ "$os" == "Darwin" ]]; then
  echo "Local IP : $(ipconfig getifaddr en0 2>/dev/null || echo n/a)"
else
  echo "Local IP : $(hostname -I 2>/dev/null | awk '{print $1}')"
fi

echo
echo "== Top 5 processes by memory =="
printf '%-12s %-8s %-6s %s\n' USER PID '%MEM' COMMAND
ps aux | sort -k4 -nr | head -5 | awk '{printf "%-12s %-8s %-6s %s\n", $1, $2, $4, $11}'
