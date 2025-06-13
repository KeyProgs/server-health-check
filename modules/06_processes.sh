#!/bin/bash

print_header "Process Health"

# Top CPU-consuming processes
echo -e "\n🔥 Top 5 CPU-consuming processes:"
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | awk '{printf "%-6s %-6s %-20s CPU: %-5s MEM: %-5s\n", $1, $2, $3, $4, $5}'

# Top Memory-consuming processes
echo -e "\n🧠 Top 5 Memory-consuming processes:"
ps -eo pid,ppid,comm,%mem,%cpu --sort=-%mem | head -n 6 | awk '{printf "%-6s %-6s %-20s MEM: %-5s CPU: %-5s\n", $1, $2, $3, $4, $5}'

# Zombie processes
ZOMBIES=$(ps aux | awk '$8=="Z" { print $2 }' | wc -l)
if [ "$ZOMBIES" -gt 0 ]; then
  print_warning "Found $ZOMBIES zombie process(es):"
  ps aux | awk '$8=="Z"'
else
  print_success "No zombie processes detected."
fi

# Stuck or uninterruptible sleep processes (D state)
STUCK=$(ps -eo pid,state,comm | awk '$2 ~ /D/' | wc -l)
if [ "$STUCK" -gt 0 ]; then
  print_warning "$STUCK process(es) in uninterruptible sleep (D state) – possible I/O hang:"
  ps -eo pid,state,comm | awk '$2 ~ /D/'
else
  print_success "No stuck I/O processes."
fi

# Hung or unresponsive processes (optional: check by custom logic or high CPU over time)
# This is a placeholder for advanced logic you can add later
