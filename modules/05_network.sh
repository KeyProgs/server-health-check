#!/bin/bash

print_header "Network Health"

# Interfaces & IP addresses
echo -e "\n🌐 Network Interfaces:"
ip -brief address | awk '{print $1 ": " $3}'

# Bandwidth stats
echo -e "\n📊 Bandwidth Usage (received/transmitted per interface):"
if command -v sar >/dev/null 2>&1; then
  sar -n DEV 1 1 | grep -v Average | tail -n +4 | awk '{printf "%-8s RX: %-10s TX: %-10s\n", $2, $5, $6}'
else
  print_warning "'sar' not installed – skipping bandwidth usage (install via sysstat)."
fi

# Active connections
echo -e "\n🔗 Active TCP Connections:"
ss -tan state established | tail -n +2 | wc -l | xargs -I{} echo "{} established connections"

# Listening ports
echo -e "\n🔓 Listening Ports (TCP/UDP):"
ss -tuln | awk 'NR==1 || $1 ~ /^(tcp|udp)/ {print}'

# DNS resolution test
echo -e "\n🌍 DNS Resolution Test:"
if ping -c1 google.com &>/dev/null; then
  print_success "DNS resolution is working."
else
  print_error "DNS resolution failed!"
fi

# Gateway ping test
GATEWAY=$(ip route | grep default | awk '{print $3}')
echo -e "\n📶 Gateway Reachability:"
if ping -c1 -W1 $GATEWAY &>/dev/null; then
  print_success "Gateway $GATEWAY is reachable."
else
  print_error "Cannot reach gateway $GATEWAY!"
fi
