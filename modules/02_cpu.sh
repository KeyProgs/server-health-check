#!/bin/bash

print_header "CPU Health"

# CPU Info
CPU_MODEL=$(lscpu | grep "Model name" | sed 's/Model name:\s*//')
CPU_CORES=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')

echo "CPU Model      : $CPU_MODEL"
echo "CPU Cores      : $CPU_CORES"
echo "Load Average   : $CPU_LOAD"

# CPU Usage Snapshot
CPU_STATS=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
CPU_USAGE=$(awk "BEGIN {print 100 - $CPU_STATS}")

echo "CPU Usage      : $CPU_USAGE%"

# Evaluation
if (( $(echo "$CPU_USAGE > 85" | bc -l) )); then
  print_error "High CPU usage detected!"
elif (( $(echo "$CPU_USAGE > 65" | bc -l) )); then
  print_warning "Moderate CPU usage."
else
  print_success "CPU usage is normal."
fi
