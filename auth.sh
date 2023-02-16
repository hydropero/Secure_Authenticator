#!/bin/bash
help()
{
   # Display Help
    clear
    echo ""
    echo "#########################################################################################"
    echo -e "#    ${CYAN}Provides function for creating encryption keys and encrypting/decrypting files${NC}     #"
    echo "#########################################################################################"
    echo ""
    echo "Create Encryption Key ~ Syntax:  [-c]"
    echo -e "Example Usage: ${BLUE}auth.sh -c${NC}"
    echo "Generates auth.key file in ${HOME_VAR}/.ssh/ or warn/prompt to regenerate if one exists"
    echo "#########################################################################################"
    echo ""
    echo "Encrypt File ~ Syntax:   [-e] 'file to encrypt'"
    echo -e "Example Usage: ${BLUE}auth.sh -e passwords.txt${NC}"
    echo "Will output encrypted file of same name with .enc extension"
    echo "#########################################################################################"
    echo ""
    echo "Decrypt File ~ Syntax:   [-d] 'file to decrypt'"
    echo -e "Example Usage: ${BLUE}auth.sh -d passwords.txt.enc${NC}"
    echo "Will output contents of file to stdout"
    echo "#########################################################################################"
    echo ""
    echo "Decrypt File ~ Syntax: [-o] [-d] 'file to decrypt'"
    echo -e "Example Usage: ${BLUE}auth.sh -o -d passwords.txt.enc${NC}"
    echo "Will decrypt encypted file in same directory"
    echo "#########################################################################################"
}
encrypt_file()
{
    openssl enc -aes-256-cbc -md sha512 -iter 100000 -salt -in $FILE_TO_ENCRYPT -out ${FILE_TO_ENCRYPT}.enc -pass file:$HOME_VAR/.ssh/${KEY_NAME} && \
    rm ${SECUREAUTHPATH}/API_DB
}

decrypt_file()
{
    if [  -n "$O_OPTION" ]
        then
            FILE_NO_EXT=$(echo "${FILE_TO_DECRYPT%.*}")
            openssl enc -aes-256-cbc -md sha512 -iter 100000 -salt -d -in ${FILE_TO_DECRYPT} -out ${FILE_NO_EXT} -pass file:$HOME/.ssh/auth.key && \
            rm ${SECUREAUTHPATH}/API_DB.enc

        else
            openssl enc -aes-256-cbc -md sha512 -iter 100000 -salt -d -in ${FILE_TO_DECRYPT} -pass file:$HOME_VAR/.ssh/${KEY_NAME}
    fi
}

create_key()
{
    FILE="${HOME}/.ssh/auth.key"
    if test -f "$FILE"; 
    then 
        read -p "$FILE already exists. Are you sure you want regenerate it? - Enter Y or N: " USERINPUT
        case "$USERINPUT" in
        Yes|yes|Y|y)
            echo "Regenerating authentication key..."
            sleep 3
            openssl rand -out "$HOME_VAR/.ssh/auth.key" 32
            echo "A new authentication key has been generated: { $KEY_NAME } in your ${HOME}/.ssh directory"
            exit 0
            ;;
        *)
            echo "You have selected to retain your existing key..."
            echo "Exiting"
            exit 0
            ;;
        esac
    else 
        openssl rand -out "$HOME_VAR/.ssh/auth.key" 32
        echo "Generated authentication key: { $KEY_NAME } in your ${HOME}/.ssh directory"
        echo "For use with the API Auth tool, ensure all users who require access have the ${RED}same key${NC} in their own ~/.ssh/ directory"
        exit 0
    fi
}

############### Variable Definitions ###############
KEY_NAME='auth.key'
HOME_VAR=${HOME}
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

while getopts ":che:od:" option
do
    case $option in
        c)
            create_key
            ;;
        h)  
            help
            ;;
        e)
            FILE_TO_ENCRYPT=${OPTARG}
            encrypt_file
            ;;
        o) 
            O_OPTION=true
            ;;
        d) 
            FILE_TO_DECRYPT=${OPTARG}
            decrypt_file
            ;;
   esac
done
if (( $OPTIND == 1 )); then
   echo "Run this tool with the -h option for details on it's usage"
fi

