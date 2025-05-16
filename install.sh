#!/bin/bash
clear
IP=$(wget -qO- ipv4.icanhazip.com)
[[ "$(whoami)" != "root" ]] && {
echo
echo "VOCÊ PRECISA EXECUTAR INSTALAÇÃO COMO ROOT!"
echo
rm install.sh
exit 0
}

ubuntuV=$(lsb_release -r | awk '{print $2}' | cut -d. -f1)

[[ $(($ubuntuV < 20)) = 1 ]] && {
clear
echo "FAVOR INSTALAR NO UBUNTU 20.04 OU 22.04! O SEU É $ubuntuV"
echo
rm /root/install.sh
exit 0
}
[[ -e /root/paineldtunnel/src/index.ts ]] && {
  clear
  echo "O PAINEL JÁ ESTÁ INSTALADO. DESEJA REMOVÊ-LO? (s/n)"
  read remo
  [[ $remo = @(s|S) ]] && {
  cd /root/paineldtunnel
  rm -r painelbackup > /dev/null
  mkdir painelbackup > /dev/null
  cp prisma/database.db painelbackup
  cp .env painelbackup
  zip -r painelbackup.zip painelbackup
  mv painelbackup.zip /root
  rm -r /root/paineldtunnel
  rm /root/install.sh
  echo "Removido com sucesso!"
  exit 0
  }
  exit 0
}
clear
echo "QUAL PORTA DESEJA ATIVAR?"
read porta
echo
echo "Instalando Painel Dtunnel Mod..."
echo
sleep 3
#========================
sudo apt-get update -y
sudo apt-get update -y
sudo apt-get install wget -y
sudo apt-get install curl -y
sudo apt-get install zip -y
sudo apt-get install npm -y /dev/null
npm install pm2 -g /dev/null
sudo apt-get install cron -y
sudo apt-get install unzip -y
sudo apt-get install screen -y
sudo apt-get install git -y
curl -s -L https://raw.githubusercontent.com/carlos-ayala/paineldtunnel/main/setup_20.x | bash
sudo apt-get install nodejs -y
#=========================
git clone https://github.com/carlos-ayala/paineldtunnel.git
cd /root/paineldtunnel 
chmod 777 pon poff menudt backmod
mv pon poff menudt backmod /bin
echo "PORT=$porta" > .env
echo "NODE_ENV=\"production\"" >> .env
echo "DATABASE_URL=\"file:./database.db\"" >> .env
token1=$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'));")
token2=$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'));")
token3=$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'));")
echo "CSRF_SECRET=\"$token1\"" >> .env
echo "JWT_SECRET_KEY=\"$token2\"" >> .env
echo "JWT_SECRET_REFRESH=\"$token3\"" >> .env
echo "ENCRYPT_FILES=\"7223fd56-e21d-4191-8867-f3c67601122a\"" >> .env
npm install
npx prisma generate
npx prisma migrate deploy
npm run start
#=========================
clear
echo
echo
echo "PAINEL DTUNNEL MOD INSTALADO COM SUCESSO!"
echo "Os Arquivos Ficam Na Pasta /root/paineldtunnel"
echo
echo "Comando para ATIVAR: pon"
echo "Comando para DESATIVAR: poff"
echo
echo -e "\033[1;36mDigite comando: \033[1;37mmenudt \033[1;32m(Para acessar o Menu do Painel) \033[0m"
echo
rm /root/install.sh
pon
echo -e "\033[1;36mSEU PAINEL:\033[1;37m http://$IP\033[0m"
echo
echo -ne "\n\033[1;31mENTER \033[1;33mPara Retornar \033[1;32mAo Prompt! \033[0m"; read
cat /dev/null > ~/.bash_history && history -c
rm -rf wget-log* > /dev/null 2>&1
rm install* > /dev/null 2>&1
sleep 3
menudt
