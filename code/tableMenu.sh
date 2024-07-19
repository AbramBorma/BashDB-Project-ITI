#!/bin/bash

DB_ROOT="../mySchemas"

"cd ./$DB_ROOT" 

table_menu() {
    echo "1- Create table"
    echo "2- List tables"
    echo "3- Select table"
    echo "4- Delete entire table"
    echo "5- insert into table"
    echo "6- update table content"
    echo "6- Exit"
    read -r -p "Choose an option: " table_choice

     case $table_choice in
        1) ./tables/createTable.sh ;;
        2) ./tables/listTables.sh ;;
        3) ./tables/selectFromTable.sh ;;
        4) ./tables/deleteTable.sh ;;
        5) ./tables/insertIntoTable.sh ;;
        6) ./tables/updateTable.sh ;;
        7) cd ..; main_menu ;;
        *) echo "Invalid option"; table_menu;;
    esac
}