#!/bin/bash

print_header "System Logs & Audit"

LOGFILE="/var/log/syslog"
[ ! -f "$LOGFILE" ] && LOGFILE="/var/log/messages"

# Last 20 system log lines
echo -e "\n📝 Last 20 System Log Entries ($LOGFILE):"
tail -n 20 "$LOGFILE"

# Recent errors
echo -e "\n❗ Recent System Errors (last 100 lines):"
grep -iE "error|fail|critical|panic" "$LOGFILE" | tail -n 10 || echo "No critical errors found."

# Last login attempts
echo -e "\n🔑 Last 5 Login Attempts:"
last -n 5 | awk '{print $1, $3, $4, $5, $6, $7}'

# Failed login attempts
echo -e "\n🚫 Failed SSH Logins:"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5 || echo "No failed SSH attempts found."

# Sudo abuse attempts
echo -e "\n⚠️ Sudo Usage Attempts:"
grep "sudo" /var/log/auth.log 2>/dev/null | tail -n 5 || echo "No recent sudo usage logged."

# Kernel panics or oops (if any)
echo -e "\n💣 Kernel Panic / Oops messages (last 100 lines of dmesg):"
dmesg | grep -iE "panic|fatal|oops" | tail -n 10 || echo "No critical kernel messages found."


# Use journalctl -xe  (systemd-based systems):
echo -e "\n🧾 Last 10 Critical Systemd Log Lines (journalctl -xe):"
journalctl -xe | tail -n 10


# Crontab last runs/errors (optional advanced hook for future)
# echo -e "\n⏱️ Crontab Summary: (coming soon)"
