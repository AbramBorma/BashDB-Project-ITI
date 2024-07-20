#!/bin/bash

source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

"cd ./$DB_ROOT" 
schemaName="$1"
checkSchemaExistance "$schemaName"

table_menu() {
    echo "Connected to schema: $schemaName"
    echo "1- Create table"
    echo "2- List tables"
    echo "3- Select table"
    echo "4- Delete entire table"
    echo "5- insert into table"
    echo "6- update table content"
    echo "6- Exit"
    read -r -p "Choose an option: " table_choice

     case $table_choice in
        1) ./tables/createTable.sh "$schemaName";;
        2) ./tables/listTables.sh "$schemaName" ;;
        3)  selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/selectFromTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        4)selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/deleteTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        5) selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/insertIntoTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        6) selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/updateTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        7) cd ..; return 0 ;;
        *) echo "Invalid option"; table_menu;;
    esac
}
table_menu
