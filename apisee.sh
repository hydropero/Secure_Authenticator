#!/opt/homebrew/Cellar/bash/5.2.15/bin/bash

help()
{
   # Display Help
    clear
    echo ""
    echo "#########################################################################################"
    echo -e "#            ${CYAN}Provides functions for interacting with encrypted API database  ${NC}            #"
    echo "#########################################################################################"
    echo ""
    echo -e "${IGREEN}Retrieve Value from DB Syntax:${NC} apisee.sh [-t] 'Item Type' [-r] 'Application Name'"
    echo -e "${IGREEN}Example Usage:${NC} ${BLUE}apisee.sh -t 'APIKEY' -r 'Zenoss'${NC}"
    echo "Will retrieve value in APIKEY column for application named Zenoss"
    echo "#########################################################################################"
    echo ""
    echo -e "${IGREEN}Retrieve all available data from DB:${NC} apisee.sh [-r] 'All'"
    echo -e "${IGREEN}Example Usage:${NC} ${BLUE}apisee.sh -r 'ALL'${NC}"
    echo "Will return table of all available data within API database"
    echo "#########################################################################################"
    echo ""
    echo "Decrypt File ~ Syntax:   [-d] 'file to decrypt'"
    echo -e "Example Usage: ${BLUE}auth.sh -d passwords.txt.enc${NC}"
    echo "Will output contents of file to stdout"
    echo "#########################################################################################"
    echo ""
}
update()
{
    echo 'lol'
}

add()
{  
    if [[ "$ADD_VALUE" =~ ^[a-zA-Z0-9\`!@\#\$\%\^\&\*\(\)\_\+\\\{\}\[\]\;\'\"\/\.\,\<\>\|]*,[a-zA-Z0-9\`!@\#\$\%\^\&\*\(\)\_\+\\\{\}\[\]\;\'\"\/\.\,\<\>\|]*,[a-zA-Z0-9\`!@\#\$\%\^\&\*\(\)\_\+\\\{\}\[\]\;\'\"\/\.\,\<\>\|]*,.*[^,]$ ]]    
        then
            NAMES_ROW=$(bash auth.sh -d API_DB.enc | cut -d ',' -f 1 )
            API_ITEM_ARRAY=(`echo $ADD_VALUE | tr ',' ' '`)
            UNIQUE_NAME=${API_ITEM_ARRAY[0]}
            if [[ "$NAMES_ROW" =~ "$UNIQUE_NAME" ]]
                then echo "Error NAME is not unique. Either update the existing key or remove it and rerun"
                else bash auth.sh -o -d 'API_DB.enc' && echo $ADD_VALUE >> 'API_DB' && bash auth.sh -e 'API_DB'
            fi
            #if [[ "$UNIQUE_NAME"  ]]
        else
            FAILED_VAR="Failed Regex Validation!"
            printf "\n\n${RED}%85s${NC}\n" "--------------- $FAILED_VAR ---------------"
            printf "\n\nEnsure Value Supplied Matches The Following Pattern: [ ${BLUE}%50s${NC} ]\n\n" "ExampleValue1,ExampleValue2,ExampleValue3,ExampleValue4"
        fi
}

delete()
{
    NAMES_ROW=$(bash auth.sh -d API_DB.enc | cut -d ',' -f 1 )
    API_ITEM_ARRAY=(`echo $ADD_VALUE | tr ',' ' '`)
    UNIQUE_NAME=${API_ITEM_ARRAY[0]}
    #if [[ "$NAMES_ROW" =~ "$UNIQUE_NAME" ]]

}

read()
{
    case "$SEARCH_TERM" in
        All|ALL|a|A)
            
            printf "\n\n${CYAN}Please Maximize Your Terminal Window${NC}\n\n"
            sleep 3
            API_ITEMS=$(bash auth.sh -d API_DB.enc)
            API_ITEMS_ARRAY=(`echo $API_ITEMS`)
            COUNT=0
            for line in "${API_ITEMS_ARRAY[@]}"
            do
                #echo $line
                if (( $COUNT == 0 ))
                    then
                    echo " "
                    echo $line | tr ',' ' ' | awk '{printf (" | ———————————————————— | ————————————————————————————————————————————— | ———————————————————————————————— | ———————————————————————————————— | \n")}'
                    echo $line | tr ',' ' ' | awk '{printf (" | %-20s | %-45s | %-32s | %-32s | \n", $1, $2, $3, $4)}'
                    echo $line | tr ',' ' ' | awk '{printf (" | ———————————————————— | ————————————————————————————————————————————— | ———————————————————————————————— | ———————————————————————————————— | \n")}'
                else    
                    echo $line | tr ',' ' ' | awk '{printf " | %-20s | %-45s | %-32s | %-32s | \n", $1, $2, $3, $4}'
                fi
                COUNT=$((COUNT + 1))
            done
            echo ""
            ;;
        *)
            API_ITEMS=$(bash auth.sh -d API_DB.enc)
            LINE=$(echo "${API_ITEMS}" | grep -i "$SEARCH_TERM")
            #echo "THIS IS LINE: $LINE"
            API_ITEM_ARRAY=(`echo $LINE | tr ',' ' '`)
            declare -A API_HASHMAP
            API_HASHMAP[NAME]=${API_ITEM_ARRAY[0]}
            API_HASHMAP[APIKEY]=${API_ITEM_ARRAY[1]}
            API_HASHMAP[SECRETKEY]=${API_ITEM_ARRAY[2]}
            API_HASHMAP[ADDITIONALVALUE]=${API_ITEM_ARRAY[3]}
            SELECTION=${SELECTION^^}
            RETURN_VALUE=${API_HASHMAP[${SELECTION}]}
            echo $RETURN_VALUE
            ;;
    esac
}

RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'
IGREEN='\033[0;92m'


while getopts "t:r:a:h" option
do
    case $option in
    u)
        update
        ;;
    a)
        ADD_VALUE=${OPTARG}
        add
        ;;
    d)
        DELETION_SELECTION=${OPTARG}
        delete
        ;;
    t)
        SELECTION=${OPTARG}
        ;;
    r)
        SEARCH_TERM=${OPTARG}
        read
        ;;
    h)
        help
        ;;
    
    

   esac
done

if (( $OPTIND == 1 )); then
   echo "Run this tool with the -h option for details on it's usage"
fi