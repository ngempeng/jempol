#!/bin/bash
NS=$( cat /etc/xray/dns )
PUB=$( cat /etc/slowdns/server.pub )
domain=$(cat /etc/xray/domain)
#color
grenbo="\e[92;1m"
NC='\e[0m'

#install dependencies
apt update && apt upgrade -y
apt install -y python3 python3-pip git unzip

#install bot scripts
cd /usr/bin
wget -O bot.zip https://raw.githubusercontent.com/ngempeng/jempol/master/limit/bot.zip
unzip bot.zip
mv bot/* /usr/bin
chmod +x /usr/bin/*
rm -rf bot.zip

#install kyt scripts
clear
wget -O kyt.zip https://raw.githubusercontent.com/ngempeng/jempol/master/limit/kyt.zip
unzip kyt.zip
pip3 install -r kyt/requirements.txt

#input data
echo -e "${grenbo}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " \e[1;97;101m          ADD BOT PANEL          \e[0m"
echo -e "${grenbo}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Tutorial Create Bot and ID Telegram:"
echo -e "${grenbo}[*] Create Bot and Get Token: @BotFather${NC}"
echo -e "${grenbo}[*] Info ID Telegram: @MissRose_bot, use command /info${NC}"
echo -e "${grenbo}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -e -p "[*] Input your Bot Token: " bottoken
read -e -p "[*] Input Your ID Telegram: " admin
echo -e BOT_TOKEN='"'$bottoken'"' >> /usr/bin/kyt/var.txt
echo -e ADMIN='"'$admin'"' >> /usr/bin/kyt/var.txt
echo -e DOMAIN='"'$domain'"' >> /usr/bin/kyt/var.txt
echo -e PUB='"'$PUB'"' >> /usr/bin/kyt/var.txt
echo -e HOST='"'$NS'"' >> /usr/bin/kyt/var.txt
clear

#set up systemd service for kyt
cat > /etc/systemd/system/kyt.service << END
[Unit]
Description=Simple kyt - @kyt
After=network.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m kyt
Restart=always

[Install]
WantedBy=multi-user.target
END

systemctl start kyt 
systemctl enable kyt
systemctl restart kyt
cd /root
rm -rf kyt.sh
echo "Done"
echo "Your Bot Data:"
echo -e "==============================="
echo "Bot Token       : $bottoken"
echo "Admin           : $admin"
echo "Domain          : $domain"
echo "Pub             : $PUB"
echo "Host            : $NS"
echo -e "==============================="
echo "Installation complete, type /menu on your bot"
