#!/bin/bash
source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

# PS3="HELLO"
mkdir -p $DB_ROOT
main_menu() {
    echo "***** Main Menu *****"
    echo ""
    echo "1- Create Schema"
    echo "2- List Schemas"
    echo "3- Connect To Schema"
    echo "4- Drop Schema"
    echo "5- Enter SQL mode"
    echo "6- Exit"
    echo ""
    read -r -p "Choose an option: " main_choice
    echo ""

    case $main_choice in
        1) echo "***** Creating a New Schema *****"
            echo ""
        read -r -p "Enter your schmema name: " schemaName
        ./databases/createSchema.sh "$schemaName"
        navigationMenu ;;
        2) ./databases/listSchemas.sh
            navigationMenu ;;
        3) source ./databases/selectSchema.sh
           source ./tableMenu.sh "$dbName";;
        4) ./databases/deleteSchema.sh
            navigationMenu ;;
        5) ./utils/sqlParse.sh ;;
        6) exit 0 ;;
        *) echo "Invalid option"; main_menu ;;
    esac
}
main_menu
