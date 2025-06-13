#!/bin/bash

print_header "Memory Health"

# Memory Stats
MEM=$(free -m)
TOTAL_MEM=$(echo "$MEM" | awk '/Mem:/ {print $2}')
USED_MEM=$(echo "$MEM" | awk '/Mem:/ {print $3}')
FREE_MEM=$(echo "$MEM" | awk '/Mem:/ {print $4}')
BUFFERS=$(echo "$MEM" | awk '/Mem:/ {print $6}')
CACHED=$(echo "$MEM" | awk '/Mem:/ {print $7}')
AVAILABLE_MEM=$(echo "$MEM" | awk '/Mem:/ {print $7}')
MEM_USAGE_PERCENT=$(awk "BEGIN {print ($USED_MEM/$TOTAL_MEM)*100}")

# Swap Stats
TOTAL_SWAP=$(echo "$MEM" | awk '/Swap:/ {print $2}')
USED_SWAP=$(echo "$MEM" | awk '/Swap:/ {print $3}')
SWAP_USAGE_PERCENT=$(awk "BEGIN {if ($TOTAL_SWAP==0) print 0; else print ($USED_SWAP/$TOTAL_SWAP)*100}")

# Display
echo "Total RAM      : ${TOTAL_MEM} MB"
echo "Used RAM       : ${USED_MEM} MB"
echo "Free RAM       : ${FREE_MEM} MB"
echo "Cached         : ${CACHED} MB"
echo "Buffers        : ${BUFFERS} MB"
echo "RAM Usage      : $(printf "%.1f" $MEM_USAGE_PERCENT)%"
echo "Swap Used      : ${USED_SWAP} MB / ${TOTAL_SWAP} MB"
echo "Swap Usage     : $(printf "%.1f" $SWAP_USAGE_PERCENT)%"

# Evaluation
if (( $(echo "$MEM_USAGE_PERCENT > 90" | bc -l) )); then
  print_error "High memory usage!"
elif (( $(echo "$MEM_USAGE_PERCENT > 75" | bc -l) )); then
  print_warning "Moderate memory usage."
else
  print_success "Memory usage is within normal range."
fi

if (( $(echo "$SWAP_USAGE_PERCENT > 40" | bc -l) )); then
  print_warning "Swap usage is above 40% – may indicate memory pressure."
elif (( $(echo "$SWAP_USAGE_PERCENT > 70" | bc -l) )); then
  print_error "Swap usage is very high – system could be struggling!"
else
  print_success "Swap usage is fine."
fi
