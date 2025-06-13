#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$BASE_DIR/reports/health_$(date +%Y%m%d_%H%M).log"
mkdir -p "$BASE_DIR/reports"

# Source utils
source "$BASE_DIR/utils/colors.sh"

# Header
echo -e "${BOLD}🩺 SERVER HEALTH CHECK - $(hostname) - $(date)${NC}" | tee "$LOG_FILE"
echo "------------------------------------------------------------" | tee -a "$LOG_FILE"

# Loop through all module scripts
for module in "$BASE_DIR/modules/"*.sh; do
  bash "$module" | tee -a "$LOG_FILE"
done

print_success "Health check completed. Report saved to: $LOG_FILE"
