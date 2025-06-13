#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
  echo -e "\n${BOLD}${CYAN}==> $1 ${NC}"
}

print_success() {
  echo -e "${GREEN}[✔] $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
  echo -e "${RED}[✖] $1${NC}"
}
