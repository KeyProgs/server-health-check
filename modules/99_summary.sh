#!/bin/bash

print_header "Final Summary"

# Timestamp info
echo -e "🕒 Report Timestamp : $(date)"
echo -e "📛 Hostname         : $(hostname)"
echo -e "📂 Report Directory : $(pwd)"

# Uptime summary
UP=$(uptime -p)
echo -e "⏳ Uptime Summary   : $UP"

# Load Average summary
LOAD=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')
echo -e "📊 Load Averages    : $LOAD (1, 5, 15 min)"

# Disk warning summary (quick scan)
DISK_WARN=$(df -h | awk 'NR>1 {gsub(/%/,"",$5); if ($5 > 85) print $6 " - " $5"%"}')
if [[ -n "$DISK_WARN" ]]; then
  echo -e "\n🚨 Disk Space Alerts:"
  echo "$DISK_WARN"
else
  print_success "No disk space alerts."
fi

# Memory usage summary
MEM_USAGE=$(free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100.0}')
echo -e "📈 RAM Usage        : ${MEM_USAGE}%"

# CPU usage summary
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo -e "🧠 CPU Usage        : ${CPU_USAGE}%"

# Process anomalies summary
ZOMBIE_COUNT=$(ps aux | awk '$8=="Z"' | wc -l)
STUCK_COUNT=$(ps -eo stat | grep -c '^D')
[[ $ZOMBIE_COUNT -gt 0 ]] && echo "🧟 Zombie Processes : $ZOMBIE_COUNT"
[[ $STUCK_COUNT -gt 0 ]] && echo "⚠️  Stuck Processes  : $STUCK_COUNT"

# Footer
echo -e "\n✅ ${BOLD}Server health check completed successfully.${NC}"
echo -e "📄 Full report logged to: ${LOG_FILE}"
