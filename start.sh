GREEN='\033[0;32m'
RESET='\033[0m'

while : 
do
    echo -e "${GREEN}Iniciando no modo anti queda, aguarde...${RESET}"
    npm run dev
    sleep 1
done
