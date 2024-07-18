#!/bin/bash

DB_ROOT="./databases"

mkdir -p $DB_ROOT

main_menu() {
    echo "1- Create Database"
    echo "2- List Databases"
    echo "3- Connect To Database"
    echo "4- Drop Database"
    echo "5- Enter SQL mode"
    echo "6- Exit"
    read -p "Choose an option: " main_choice

    case $main_choice in
        1) ./create_database.sh ;;
        2) ./list_databases.sh ;;
        3) ./connect_database.sh ;;
        4) ./drop_database.sh ;;
        5) ./sqlParse.sh ;;
        6) exit 0 ;;
        *) echo "Invalid option"; main_menu ;;
    esac
}
main_menu

