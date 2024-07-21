#!/bin/bash

DB_ROOT="../mySchemas"

# PS3="HELLO"
mkdir -p $DB_ROOT
main_menu() {
    echo "1- Create Schema"
    echo "2- List Schemas"
    echo "3- Connect To Schema"
    echo "4- Drop Schema"
    echo "5- Enter SQL mode"
    echo "6- Exit"
    read -p "Choose an option: " main_choice

    case $main_choice in
        1) read -r -p "Enter your schmema name: " schemaName
        ./databases/createSchema.sh "$schemaName"
        ;;
        2) ./databases/listSchemas.sh ;;
        3) source ./databases/selectSchema.sh
           source ./tableMenu.sh "$dbName" && table_menu;;
        4) ./databases/deleteSchema.sh ;;
        5) ./utils/sqlParse.sh ;;
        6) exit 0 ;;
        *) echo "Invalid option"; main_menu ;;
    esac
}
main_menu

