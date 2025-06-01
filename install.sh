#!/bin/bash
clear
IP=$(wget -qO- ipv4.icanhazip.com)

# Verifica si es root
[[ "$(whoami)" != "root" ]] && {
  echo -e "\n\033[1;31m¡NECESITAS EJECUTAR LA INSTALACIÓN COMO ROOT!\033[0m\n"
  rm -f install.sh
  exit 1
}

# Verifica versión de Ubuntu
ubuntuV=$(lsb_release -r | awk '{print $2}' | cut -d. -f1)
[[ $(($ubuntuV < 20)) = 1 ]] && {
  clear
  echo -e "\033[1;31m¡POR FAVOR, INSTALA EN UBUNTU 20.04 O 22.04! EL TUYO ES $ubuntuV\033[0m"
  rm -f /root/install.sh
  exit 1
}

# Si ya existe, pregunta si desea eliminar
[[ -e /root/paineldtunnel/src/index.ts ]] && {
  clear
  echo -e "\033[1;33mEL PANEL YA ESTÁ INSTALADO.\033[0m"
  echo "¿DESEAS ELIMINARLO Y REINSTALARLO? (s/n)"
  read -r remo
  [[ $remo =~ ^[sS]$ ]] && {
    cd /root/paineldtunnel || exit
    rm -rf painelbackup > /dev/null
    mkdir painelbackup
    cp prisma/database.db .env painelbackup/
    zip -r painelbackup.zip painelbackup > /dev/null
    mv painelbackup.zip /root/
    cd /root || exit
    rm -rf /root/paineldtunnel
    rm -f install.sh
    echo -e "\n\033[1;32m¡Panel eliminado y respaldo creado en /root/painelbackup.zip!\033[0m"
    exit 0
  }
  exit 0
}

# Pregunta el puerto
clear
echo "¿QUÉ PUERTO DESEAS ACTIVAR PARA EL PANEL WEB?"
read -r porta
echo
echo -e "\033[1;34mInstalando Panel Dtunnel Mod...\033[0m"
sleep 2

#========================
apt-get update -y
apt-get install wget curl zip npm cron unzip screen git -y
npm install -g pm2
curl -sL https://raw.githubusercontent.com/carlos-ayala/paineldtunnel/main/setup_20.x | bash
apt-get install nodejs -y
#========================

# Clona el repositorio y configura permisos
git clone https://github.com/carlos-ayala/paineldtunnel.git
cd /root/paineldtunnel || exit
chmod +x pon poff menudt backmod
mv pon poff menudt backmod /bin/

# Crea archivo .env
echo "PORT=$porta" > .env
echo "NODE_ENV=\"production\"" >> .env
echo "DATABASE_URL=\"file:./database.db\"" >> .env
echo "CSRF_SECRET=\"$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'))")\"" >> .env
echo "JWT_SECRET_KEY=\"$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'))")\"" >> .env
echo "JWT_SECRET_REFRESH=\"$(node -e "console.log(require('crypto').randomBytes(100).toString('base64'))")\"" >> .env
echo "ENCRYPT_FILES=\"7223fd56-e21d-4191-8867-f3c67601122a\"" >> .env

# Instala dependencias y prepara el panel
npm install
npx prisma generate
npx prisma migrate deploy
npm run start

# Mensaje final
clear
echo -e "\n\033[1;32m¡PANEL DTUNNEL MOD INSTALADO CON ÉXITO!\033[0m"
echo "Los archivos se encuentran en: \033[1;37m/root/paineldtunnel\033[0m"
echo -e "\nComando para \033[1;32mACTIVAR:\033[0m pon"
echo "Comando para \033[1;31mDESACTIVAR:\033[0m poff"
echo -e "\nUsa el comando \033[1;36mmenudt\033[0m para gestionar usuarios desde consola"
echo
rm -f /root/install.sh
pon
echo -e "\n\033[1;36mACCEDE A TU PANEL:\033[1;37m http://$IP:$porta\033[0m\n"
echo -ne "\033[1;33mPulsa ENTER para finalizar...\033[0m"
read
history -c
rm -rf wget-log* install*
sleep 2
menudt