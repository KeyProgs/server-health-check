✅ README.md – Usage, Setup, and Features
markdown
Copy
Edit
# 🩺 Linux Server Health Check Tool

A modular, scalable, and super-powerful Bash tool to check the full health of any Linux server.

## 🚀 Features

- Modular health checks (CPU, RAM, disk, network, processes, logs)
- Colored output + structured logs
- Threshold-based alerts (configurable)
- Detects zombies, stuck processes, disk pressure, etc.
- Easy to extend with custom modules
- Optional email reporting

## 🛠️ Installation

```bash
git clone https://github.com/yourname/server-health-check.git
cd server-health-check
./install.sh


📦 Usage
bash healthcheck.sh

Or set a cron job for daily reports:
0 6 * * * /path/to/server-health-check/healthcheck.sh > /dev/null


⚙️ Configuration
Edit config/settings.conf to adjust thresholds, toggle log/email features, and customize alerts.

📄 Reports
All reports are saved under the reports/ folder as health_YYYYMMDD_HHMM.log.

📬 Email Reporting (Optional)
Enable it in settings.conf:

ENABLE_EMAIL_REPORT=true
EMAIL_TO="you@example.com"

Make sure mail or an MTA like ssmtp or msmtp is installed.




---
### ✅ `install.sh` – Quick Setup Script

```bash
#!/bin/bash

echo "🛠️ Installing Server Health Check Tool..."

chmod +x healthcheck.sh
find modules/ -type f -name "*.sh" -exec chmod +x {} \;
chmod +x utils/colors.sh

echo "✅ All scripts made executable."
echo "🔧 Checking for optional tools (sar, mail)..."

MISSING=""
for cmd in sar mail; do
  if ! command -v $cmd &> /dev/null; then
    MISSING+="$cmd "
  fi
done

if [[ -n "$MISSING" ]]; then
  echo "⚠️  Optional tools missing: $MISSING"
  echo "👉 Install via: sudo apt install sysstat mailutils"
else
  echo "✅ All optional tools found."
fi

echo "📂 You can now run: ./healthcheck.sh"
