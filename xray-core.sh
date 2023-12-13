#!/bin/bash
# Menu For Script
# Edition : Stable Edition V15.7.1
# Author  : Server Premium VIP
# (C) Copyright 2023-2024
# My Telegram : https://t.me/ServerPremiumVIP
#Instal Xray
function install_xray() {
clear
    print_install "Core Xray 1.8.6 Latest Version"
    # install xray
    #echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
    chown www-data.www-data $domainSock_dir
    
    # / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
#bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.8.6

    # // Ambil Config Server
    wget -O /etc/xray/config.json "${REPO}limit/config.json" >/dev/null 2>&1
    #wget -O /usr/local/bin/xray "${REPO}xray/xray.linux.64bit" >/dev/null 2>&1
    wget -O /etc/systemd/system/runn.service "${REPO}limit/runn.service" >/dev/null 2>&1
    #chmod +x /usr/local/bin/xray
    domain=$(cat /etc/xray/domain)
    IPVS=$(cat /etc/xray/ipvps)
    print_success "Core Xray 1.8.6 Latest Version"
