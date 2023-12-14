#!/bin/bash
### Color
dnf upgrade -y
dnf update -y
dnf install -y epel-release
dnf install lolcat -y
gem install lolcat
dnf install wondershaper -y
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
WHITE='\033[0;37m'
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'
TIMES="10"
CHATID=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 3)
KEY=$(grep -E "^#bot# " "/etc/bot/.bot.db" | cut -d ' ' -f 2)
URL="https://api.telegram.org/bot$KEY/sendMessage"
# ===================
clear

