#!/bin/bash

print_header "System Information"

HOSTNAME=$(hostname)
OS=$(uname -o)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
LAST_BOOT=$(who -b | awk '{print $3, $4}')

echo "Hostname       : $HOSTNAME"
echo "OS             : $OS"
echo "Kernel Version : $KERNEL"
echo "Uptime         : $UPTIME"
echo "Last Boot      : $LAST_BOOT"
