#!/bin/bash

print_header "Disk & Filesystem Health"

echo -e "\n📦 Disk Usage per Mount Point:"
df -hT -x tmpfs -x devtmpfs | awk 'NR==1 || $6 ~ /^\// {print $0}'

echo -e "\n📁 Inode Usage per Mount Point:"
df -hi -x tmpfs -x devtmpfs | awk 'NR==1 || $6 ~ /^\// {print $0}'

# Disk Space Warnings
echo -e "\n🔍 Checking Disk Usage Thresholds:"
THRESHOLD=85
while read -r line; do
  USAGE=$(echo $line | awk '{print $6}' | tr -d '%')
  MOUNT=$(echo $line | awk '{print $7}')
  if [[ "$USAGE" -ge "$THRESHOLD" ]]; then
    print_warning "Mount point $MOUNT is ${USAGE}% full!"
  fi
done <<< "$(df -h | grep -vE '^Filesystem|tmpfs|udev')"

# Inode Warnings
echo -e "\n🔍 Checking Inode Usage Thresholds:"
while read -r line; do
  IUSAGE=$(echo $line | awk '{print $5}' | tr -d '%')
  MOUNT=$(echo $line | awk '{print $6}')
  if [[ "$IUSAGE" -ge "$THRESHOLD" ]]; then
    print_warning "Mount point $MOUNT has ${IUSAGE}% inode usage!"
  fi
done <<< "$(df -hi | grep -vE '^Filesystem|tmpfs|udev')"

print_success "Disk check completed."
