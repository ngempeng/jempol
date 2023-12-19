#!/bin/bash

### Color
apt upgrade -y
apt update -y
apt install lolcat -y
gem install lolcat
apt install wondershaper -y

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

# Exporting IP Address Information
export IP=$(curl -sS icanhazip.com)

# Banner
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "  Welcome To SCRIPT ${YELLOW}(${NC}${green} Stable Edition ${NC}${YELLOW})${NC}"
echo -e " This Will Quick Setup VPN Server On Your Server"
echo -e "  Author : ${green} https://t.me/erfanrinanda ®${NC}${YELLOW}(${NC} ${green} ErfanRinanda ${NC}${YELLOW})${NC}"
echo -e " © Recode By Erfan Rinanda{YELLOW}(${NC} 2023 ${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 2

# IZIN SC
# Checking OS Architecture
if [[ $(uname -m | awk '{print $1}') == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$(uname -m)${NC} )"
else
    echo -e "${ERROR} Your Architecture Is Not Supported ( ${YELLOW}$(uname -m)${NC} )"
    exit 1
fi

# Checking System
supported_os=("ubuntu" "debian")
current_os=$(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')
if [[ " ${supported_os[@]} " =~ " ${current_os} " ]]; then
    echo -e "${OK} Your OS Is Supported ( ${green}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
else
    echo -e "${ERROR} Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC} )"
    exit 1
fi

# IP Address Validating
if [[ -z $IP ]]; then
    echo -e "${ERROR} IP Address ( ${YELLOW}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${green}$IP${NC} )"
fi

# Validate Successful
echo ""
read -p "$(echo -e "Press ${GRAY}[ ${NC}${green}Enter${NC} ${GRAY}]${NC} For Starting Installation") "
echo ""
clear

# Check if running as root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi

if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

# IZIN SCRIPT
MYIP=$(curl -sS ipv4.icanhazip.com)
echo -e "\e[32mloading...\e[0m"
clear

# Version sc
clear

# USERNAME
rm -f /usr/bin/user
username=$(curl -sS https://raw.githubusercontent.com/ServerPremiumVIP/VPS/master/Aktivasi | grep $MYIP | awk '{print $2}')
echo "$username" >/usr/bin/user

# Validity
rm -f /usr/bin/e
today=$(date -d "0 days" +"%Y-%m-%d")
valid=$(curl -sS https://raw.githubusercontent.com/ServerPremiumVIP/VPS/master/Aktivasi | grep $MYIP | awk '{print $3}')
echo "$valid" >/usr/bin/e

# DETAIL ORDER
username=$(cat /usr/bin/user)
oid=$(cat /usr/bin/ver)
exp=$(cat /usr/bin/e)
clear

# CERTIFICATE STATUS
d1=$(date -d "$valid" +%s)
d2=$(date -d "$today" +%s)
certificate=$(((d1 - d2) / 86400))

# VPS Information
DATE=$(date +'%Y-%m-%d')

# Status EXPIRED Active | Geo Project
Info="${GREEN}Active${NC}"
Error="${RED}Expired${NC}"

if [[ "$certificate" -le "0" ]]; then
    sts="${Error}"
    echo -e " $BLUE╭──────────────────────────────────────────────────────────╮${NC}"
    echo -e " $BLUE│$NC$RED    IP address not authorized by admin $NC"
    echo -e " $BLUE│$NC$RED    Please contact admin to rent this script $NC"
    echo -e " $BLUE│$NC$r • $NC$WHITE Telegram :$NC $GREEN https://t.me/erfanrinanda$NC"
    echo -e " $BLUE│$NC$r • $NC$WHITE Telegram :$NC $GREEN https://t.me/ServerPremiumVIP$NC"
    echo -e " $BLUE╰──────────────────────────────────────────────────────────╯${NC}"
    sleep 3
    exit 1
else
    sts="${Info}"
fi

echo -e "\e[32mloading...\e[0m"
clear

# REPO
REPO="https://raw.githubusercontent.com/ngempeng/jempol/master/"

# Start Installation
start=$(date +%s)
secs_to_human() {
    echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}

# Status
function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}

function print_install() {
    echo -e "${green} =============================== ${FONT}"
    echo -e "${YELLOW} # $1 ${FONT}"
    echo -e "${green} =============================== ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
        echo -e "${green} =============================== ${FONT}"
        echo -e "${Green} # $1 berhasil dipasang"
        echo -e "${green} =============================== ${FONT}"
        sleep 2
    fi
}

# Check root
function is_root() {
    if [[ 0 == "$UID" ]]; then
        print_ok "Root user Start installation process"
    else
        print_error "The current user is not the root user, please switch to the root user and run the script again"
    fi
}

# Create xray directory
print_install "Creating xray directory"
mkdir -p /etc/xray
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain
mkdir -p /var/log/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
mkdir -p /var/lib/kyt >/dev/null 2>&1

# Ram Information
mem_used=0
mem_total=0

while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used += ${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used += ${b/kB})) ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable") mem_used="$((mem_used -= ${b/kB}))" ;;
    esac
done < /proc/meminfo

Ram_Usage="$((mem_used / 1024))"
Ram_Total="$((mem_total / 1024))"
tanggal=$(date -d "0 days" +"%d-%m-%Y - %X")
OS_Name=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g')
Kernel=$(uname -r)
Arch=$(uname -m)
IP=$(curl -s https://ipinfo.io/ip/)

# Change Environment System
function first_setup() {
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

    print_install "Directory Xray"

    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        echo "Setup Dependencies $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt update -y
        apt -y install
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        echo "Setup Dependencies For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt update -y
        apt -y install haproxy
    else
        echo -e " Your OS Is Not Supported ($(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g') )"
        exit 1
    fi
}

# Geo Project
clear

function nginx_install() {
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt install nginx -y
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt -y install nginx
    else
        echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
    fi
}

function base_package() {
    clear
    ########
    print_install "Installing Required Packages"
    apt install zip pwgen openssl netcat socat cron bash-completion -y
    apt install figlet -y
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y
    systemctl enable chronyd
    systemctl restart chronyd
    systemctl enable chrony
    systemctl restart chrony
    chronyc sourcestats -v
    chronyc tracking -v
    apt install ntpdate -y
    ntpdate pool.ntp.org
    apt install sudo -y
    apt clean all
    apt autoremove -y
    apt install -y debconf-utils
    apt remove --purge exim4 -y
    apt remove --purge ufw firewalld -y
    apt install -y --no-install-recommends software-properties-common
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    apt install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential gcc g++ python2 python3 htop lsof tar wget curl ruby zip unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates bsd-mailx iptables iptables-persistent netfilter-persistent net-tools openssl ca-certificates gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa
    print_install "Required Packages Installed"
}

# Domain Input Function
function pasang_domain() {
    echo -e ""
    clear
    echo -e "   .----------------------------------."
    echo -e "   |\e[1;32mPlease Select a Domain Type Below \e[0m|"
    echo -e "   '----------------------------------'"
    echo -e "     \e[1;32m1)\e[0m Use Your Own Domain"
    echo -e "     \e[1;32m2)\e[0m Use Random Domain (Digital Ocean Only) ✖️ "
    echo -e "   ------------------------------------"
    read -p "   Please select numbers 1-2 or Any Button(Random): " host
    echo ""
    if [[ $host == "1" ]]; then
        echo -e "   \e[1;32mPlease Enter Your Subdomain $NC"
        read -p "   Subdomain: " host1
        echo "IP=" >> /var/lib/kyt/ipvps.conf
        echo $host1 > /etc/xray/domain
        echo $host1 > /root/domain
        echo ""
    elif [[ $host == "2" ]]; then
        wget ${REPO}limit/cf.sh && chmod +x cf.sh && ./cf.sh
        rm -f /root/cf.sh
        clear
    else
        print_install "Random Subdomain/Domain is Used"
        clear
    fi
}

clear
# Change Default Password
function restart_system() {
    USRSC=$(curl -sS https://raw.githubusercontent.com/ServerPremiumVIP/VPS/master/Aktivasi | grep $MYIP | awk '{print $2}')
    EXPSC=$(curl -sS https://raw.githubusercontent.com/ServerPremiumVIP/VPS/master/Aktivasi | grep $MYIP | awk '{print $3}')
    DATEVPS=$(date +'%d/%m/%Y')
    ISP=$(cat /etc/xray/isp)
    TIMEZONE=$(printf '%(%H:%M:%S)T')
    TEXT="
<code>────────────────────</code>
<b>⚡AUTOSCRIPT PREMIUM⚡</b>
<code>────────────────────</code>
<code>Owner    :</code><code>$username</code>
<code>Domain   :</code><code>$domain</code>
<code>IPVPS    :</code><code>$IPVPS</code>
<code>ISP      :</code><code>$ISP</code>
<code>DATE     :</code><code>$DATEVPS</code>
<code>Time     :</code><code>$TIMEZONE</code>
<code>Exp Sc.  :</code><code>$exp</code>
<code>────────────────────</code>
<b> SCRIPT NOTIF </b>
<code>────────────────────</code>
<i>Automatic Notifications From Github</i>
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ","url":"https://t.me/erfanrinanda"}]]}' 
    curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}

clear
# Install SSL
function install_ssl() {
    clear
    print_install "Installing SSL for Domain"
    
    domain=$(cat /root/domain)
    STOPWEBSERVER=$(lsof -i:80 | awk 'NR==2 {print $1}')
    
    rm -rf /etc/xray/xray.key
    rm -rf /etc/xray/xray.crt
    rm -rf /root/.acme.sh
    mkdir /root/.acme.sh
    systemctl stop $STOPWEBSERVER
    systemctl stop nginx
    
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    
    chmod 777 /etc/xray/xray.key
    
    print_success "SSL Certificate Installed"
}

# Create Xray folders
function create_xray_folders() {
    rm -rf /etc/vmess/.vmess.db
    rm -rf /etc/vless/.vless.db
    rm -rf /etc/trojan/.trojan.db
    rm -rf /etc/shadowsocks/.shadowsocks.db
    rm -rf /etc/ssh/.ssh.db
    rm -rf /etc/bot/.bot.db
    
    mkdir -p /etc/bot
    mkdir -p /etc/xray
    mkdir -p /etc/vmess
    mkdir -p /etc/vless
    mkdir -p /etc/trojan
    mkdir -p /etc/shadowsocks
    mkdir -p /etc/ssh
    mkdir -p /usr/bin/xray/
    mkdir -p /var/log/xray/
    mkdir -p /var/www/html
    mkdir -p /etc/kyt/limit/vmess/ip
    mkdir -p /etc/kyt/limit/vless/ip
    mkdir -p /etc/kyt/limit/trojan/ip
    mkdir -p /etc/kyt/limit/ssh/ip
    mkdir -p /etc/limit/vmess
    mkdir -p /etc/limit/vless
    mkdir -p /etc/limit/trojan
    mkdir -p /etc/limit/ssh
    chmod +x /var/log/xray
    touch /etc/xray/domain
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    touch /etc/vmess/.vmess.db
    touch /etc/vless/.vless.db
    touch /etc/trojan/.trojan.db
    touch /etc/shadowsocks/.shadowsocks.db
    touch /etc/ssh/.ssh.db
    touch /etc/bot/.bot.db
    echo "& plughin Account" >>/etc/vmess/.vmess.db
    echo "& plughin Account" >>/etc/vless/.vless.db
    echo "& plughin Account" >>/etc/trojan/.trojan.db
    echo "& plughin Account" >>/etc/shadowsocks/.shadowsocks.db
    echo "& plughin Account" >>/etc/ssh/.ssh.db
    print_success "Xray Folders Created"
}

# Install Xray
function install_xray() {
    clear
    print_install "Installing Xray Core 1.8.4 Latest Version"
    
    domainSock_dir="/run/xray"
    [ ! -d $domainSock_dir ] && mkdir $domainSock_dir
    chown www-data.www-data $domainSock_dir
    
    latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
    
    wget -O /etc/xray/config.json "${REPO}limit/config.json" >/dev/null 2>&1
    wget -O /etc/systemd/system/runn.service "${REPO}limit/runn.service" >/dev/null 2>&1
    
    chmod +x /etc/systemd/system/runn.service
    
    rm -rf /etc/systemd/system/xray.service.d
    
    cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
    
    print_success "Xray Core 1.8.4 Installed"
    
    clear
    
    print_install "Installing Configuration Files"
    
    wget -O /etc/haproxy/haproxy.cfg "${REPO}limit/haproxy.cfg" >/dev/null 2>&1
    wget -O /etc/nginx/conf.d/xray.conf "${REPO}limit/xray.conf" >/dev/null 2>&1
    sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
    
    curl ${REPO}limit/nginx.conf > /etc/nginx/nginx.conf
    
    cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem
    
    print_success "Configuration Files Installed"
}

# Install Password for SSH
function install_ssh_password() {
    clear
    print_install "Installing Password for SSH"
    
    wget -O /etc/pam.d/common-password "${REPO}limit/password"
    chmod +x /etc/pam.d/common-password
    
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/compose select No compose key"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layoutcode string de"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/modelcode string pc105"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/optionscode string "
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/switch select No temporary switch"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/toggle select No toggling"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_options boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_layout boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_options boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variantcode string "
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/xkb-keymap select "
    
    # go to root
    cd
    
    # Edit file /etc/systemd/system/rc-local.service
    cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
    
    # nano /etc/rc.local
    cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END
}
# Ubah izin akses
chmod +x /etc/rc.local

# Enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# Disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# Update
# Set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# Set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

function print_success() {
  echo -e "\e[32m[SUCCESS]\e[0m $1"
}

function udp_mini() {
  clear
  print_success "Memasang Service Limit Quota"
  wget https://raw.githubusercontent.com/ngempeng/jempol/master/limit/limit.sh && chmod +x limit.sh && ./limit.sh

  cd
  wget -q -O /usr/bin/limit-ip "${REPO}limit/limit-ip"
  chmod +x /usr/bin/*
  cd /usr/bin
  sed -i 's/\r//' limit-ip
  cd
  clear

  # SERVICE LIMIT ALL IP
  cat >/etc/systemd/system/vmip.service <<EOF
[Unit]
Description=My
ProjectAfter=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vmip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl restart vmip
  systemctl enable vmip

  cat >/etc/systemd/system/vlip.service <<EOF
[Unit]
Description=My
ProjectAfter=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vlip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl restart vlip
  systemctl enable vlip

  cat >/etc/systemd/system/trip.service <<EOF
[Unit]
Description=My
ProjectAfter=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip trip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl restart trip
  systemctl enable trip
  # SERVICE LIMIT QUOTA

  # SERVICE VMESS
  # Installing UDP Mini
  mkdir -p /usr/local/kyt/
  wget -q -O /usr/local/kyt/udp-mini "${REPO}limit/udp-mini"
  chmod +x /usr/local/kyt/udp-mini
  wget -q -O /etc/systemd/system/udp-mini-1.service "${REPO}limit/udp-mini-1.service"
  wget -q -O /etc/systemd/system/udp-mini-2.service "${REPO}limit/udp-mini-2.service"
  wget -q -O /etc/systemd/system/udp-mini-3.service "${REPO}limit/udp-mini-3.service"
  systemctl disable udp-mini-1
  systemctl stop udp-mini-1
  systemctl enable udp-mini-1
  systemctl start udp-mini-1
  systemctl disable udp-mini-2
  systemctl stop udp-mini-2
  systemctl enable udp-mini-2
  systemctl start udp-mini-2
  systemctl disable udp-mini-3
  systemctl stop udp-mini-3
  systemctl enable udp-mini-3
  systemctl start udp-mini-3
  print_success "Limit Quota Service"
}

function ssh_slow() {
  clear
  # Installing UDP Mini
  print_success "Memasang modul SlowDNS Server"
  wget -q -O /tmp/nameserver "${REPO}limit/nameserver" >/dev/null 2>&1
  chmod +x /tmp/nameserver
  bash /tmp/nameserver | tee /root/install.log
  print_success "SlowDNS"
}

clear
function ins_SSHD() {
  clear
  print_success "Memasang SSHD"
  wget -q -O /etc/ssh/sshd_config "${REPO}limit/sshd" >/dev/null 2>&1
  chmod 700 /etc/ssh/sshd_config
  /etc/init.d/ssh restart
  systemctl restart ssh
  /etc/init.d/ssh status
  print_success "SSHD"
}

clear
function ins_dropbear() {
  clear
  print_success "Menginstall Dropbear"
  # Installing Dropbear
  apt install dropbear -y > /dev/null 2>&1
  wget -q -O /etc/default/dropbear "${REPO}limit/dropbear.conf"
  chmod +x /etc/default/dropbear
  /etc/init.d/dropbear restart
  /etc/init.d/dropbear status
  print_success "Dropbear"
}

clear
function ins_vnstat() {
  clear
  print_success "Menginstall Vnstat"
  # Setting vnstat
  apt -y install vnstat > /dev/null 2>&1
  /etc/init.d/vnstat restart
  apt -y install libsqlite3-dev > /dev/null 2>&1
  wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
  tar zxvf vnstat-2.6.tar.gz
  cd vnstat-2.6
  ./configure --prefix=/usr --sysconfdir=/etc && make && make install
  cd
  vnstat -u -i $NET
  sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
  chown vnstat:vnstat /var/lib/vnstat -R
  systemctl enable vnstat
  /etc/init.d/vnstat restart
  /etc/init.d/vnstat status
  rm -f /root/vnstat-2.6.tar.gz
  rm -rf /root/vnstat-2.6
  print_success "Vnstat"
}

function ins_openvpn() {
  clear
  print_success "Menginstall OpenVPN"
  # OpenVPN
  wget ${REPO}limit/openvpn && chmod +x openvpn && ./openvpn
  /etc/init.d/openvpn restart
  print_success "OpenVPN"
}

function ins_backup() {
  clear
  print_success "Memasang Backup Server"
  # BackupOption
  apt install rclone -y
  printf "q\n" | rclone config
  wget -O /root/.config/rclone/rclone.conf "${REPO}limit/rclone.conf"
  # Install Wondershaper
  cd /bin
  git clone  https://github.com/magnific0/wondershaper.git
  cd wondershaper
  sudo make install
  cd
  rm -rf wondershaper
  echo > /home/limit
  apt install msmtp-mta ca-certificates bsd-mailx -y
  cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user serverkubackup@gmail.com
from serverkubackup@gmail.com
password serverkubackup 2023 
logfile ~/.msmtp.log
EOF
  chown -R www-data:www-data /etc/msmtprc
  wget -q -O /etc/ipserver "${REPO}limit/ipserver" && bash /etc/ipserver
  print_success "Backup Server"
}

clear
function ins_swab() {
  clear
  print_success "Memasang Swap 1 G"
  gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
  gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
  curl -sL "$gotop_link" -o /tmp/gotop.deb
  dpkg -i /tmp/gotop.deb >/dev/null 2>&1

  # > Buat swap sebesar 1G
  dd if=/dev/zero of=/swapfile bs=1024 count=1048576
  mkswap /swapfile
  chown root:root /swapfile
  chmod 0600 /swapfile >/dev/null 2>&1
  swapon /swapfile >/dev/null 2>&1
  sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

  # > Singkronisasi jam
  chronyd -q 'server 0.id.pool.ntp.org iburst'
  chronyc sourcestats -v
  chronyc tracking -v

  wget ${REPO}limit/bbr.sh &&  chmod +x bbr.sh && ./bbr.sh
  print_success "Swap 1 G"
}

function ins_Fail2ban() {
  clear
  print_success "Menginstall Fail2ban"
  apt -y install fail2ban > /dev/null 2>&1
  sudo systemctl enable --now fail2ban
  /etc/init.d/fail2ban restart
  /etc/init.d/fail2ban status

  # Instal DDOS Flate
  if [ -d '/usr/local/ddos' ]; then
    echo; echo; echo "Please un-install the previous version first"
    exit 0
  else
    mkdir /usr/local/ddos
  fi

  clear
  # banner
  echo "Banner /etc/kyt.txt" >>/etc/ssh/sshd_config
  sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/kyt.txt"@g' /etc/default/dropbear

  # Ganti Banner
  wget -O /etc/kyt.txt "${REPO}limit/issue.net"
  print_success "Fail2ban"
}

function ins_epro() {
  clear
  print_success "Menginstall ePro WebSocket Proxy"
  wget -O /usr/bin/ws "${REPO}limit/ws" >/dev/null 2>&1
  wget -O /usr/bin/tun.conf "${REPO}limit/tun.conf" >/dev/null 2>&1
  wget -O /etc/systemd/system/ws.service "${REPO}limit/ws.service" >/dev/null 2>&1
  chmod +x /etc/systemd/system/ws.service
  chmod +x /usr/bin/ws
  chmod 644 /usr/bin/tun.conf
  systemctl disable ws
  systemctl stop ws
  systemctl enable ws
  systemctl start ws
  systemctl restart ws
  wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" >/dev/null 2>&1
  wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" >/dev/null 2>&1
  wget -O /usr/sbin/ftvpn "${REPO}limit/ftvpn" >/dev/null 2>&1
  chmod +x /usr/sbin/ftvpn
  iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
  iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
  iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
  iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
  iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
  iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
  iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
  iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
  iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
  iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
  iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
  iptables-save > /etc/iptables.up.rules
  iptables-restore -t < /etc/iptables.up.rules
  netfilter-persistent save
  netfilter-persistent reload

# Function to remove unnecessary files
function remove_unnecessary_files() {
    cd
    apt autoclean -y >/dev/null 2>&1
    apt autoremove -y >/dev/null 2>&1
    print_success "Remove Unnecessary Files"
}

# Function to restart services
function restart_all_services() {
    clear
    print_success "Restarting All Services"
    
    services=("nginx" "openvpn" "ssh" "dropbear" "fail2ban" "vnstat" "haproxy" "cron" "netfilter-persistent")

    for service in "${services[@]}"; do
        /etc/init.d/"$service" restart
    done
    
    systemctl restart netfilter-persistent
    systemctl daemon-reload

    systemctl enable --now nginx xray rc-local dropbear openvpn cron haproxy netfilter-persistent ws fail2ban

    history -c
    echo "unset HISTFILE" >> /etc/profile

    cd
    rm -f /root/openvpn /root/key.pem /root/cert.pem

    print_success "All Services Restarted"
}

# Function to install menu
function install_menu() {
    clear
    print_success "Installing Menu Packet"
    wget ${REPO}limit/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu menu.zip
}

# Function to create default menu
function profile(){
clear
    cat >/root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
mesg n || true
menu
EOF

cat >/etc/cron.d/xp_all <<-END
		SHELL=/bin/sh
		PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
		2 0 * * * root /usr/local/sbin/xp
	END
	cat >/etc/cron.d/logclean <<-END
		SHELL=/bin/sh
		PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
		*/20 * * * * root /usr/local/sbin/clearlog
		END
    chmod 644 /root/.profile
	
    cat >/etc/cron.d/daily_reboot <<-END
		SHELL=/bin/sh
		PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
		0 5 * * * root /sbin/reboot
	END

    echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
    echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
    service cron restart
    cat >/home/daily_reboot <<-END
		5
	END

cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

echo "/bin/false" >>/etc/shells
echo "/usr/sbin/nologin" >>/etc/shells
cat >/etc/rc.local <<EOF
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

    chmod +x /etc/rc.local
    
    AUTOREB=$(cat /home/daily_reboot)
    SETT=11
    if [ $AUTOREB -gt $SETT ]; then
        TIME_DATE="PM"
    else
        TIME_DATE="AM"
    fi
    print_success "Default Menu Created"
}

# Function to enable services
function enable_services() {
    clear
    print_success "Enable Service"
    
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now rc-local cron netfilter-persistent

    services=("nginx" "xray" "dropbear" "openvpn" "cron" "haproxy" "ws" "fail2ban")

    for service in "${services[@]}"; do
        systemctl restart "$service"
        systemctl enable --now "$service"
    done

    print_success "Services Enabled"
    clear
}

# Function to perform the installation
function install() {
    clear
    first_setup
    nginx_install
    base_package
    make_folder_xray
    pasang_domain
    password_default
    pasang_ssl
    install_xray
    ssh
    udp_mini
    ssh_slow
    ins_SSHD
    ins_dropbear
    ins_vnstat
    ins_openvpn
    ins_backup
    ins_swab
    ins_Fail2ban
    ins_epro
    restart_all_services
    install_menu
    create_default_menu
    enable_services
    restart_system
}

install
echo ""
history -c
rm -rf /root/menu /root/*.zip /root/*.sh /root/LICENSE /root/README.md /root/domain
secs_to_human "$(($(date +%s) - ${start}))"
sudo hostnamectl set-hostname $username
echo -e "${green}Script Successfully Installed"
echo ""
read -p "$(echo -e "Press ${YELLOW}[${NC}${YELLOW}Enter${NC} ${YELLOW}]${NC} For Reboot") "
reboot