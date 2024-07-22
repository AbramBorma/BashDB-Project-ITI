#!/bin/bash
source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"
schemaName="$1"
checkSchemaExistance "$DB_ROOT/$schemaName"

table_menu() {
    echo "Connected to '$schemaName' Schema Succesfully!"
    echo ""
    echo "***** How Do You Want to Manipulate '$schemaName' Schema *****" 
    echo ""
    echo "1- Create Table"
    echo "2- List Tables"
    echo "3- Select Table"
    echo "4- Delete Entire Table"
    echo "5- Insert Into Table"
    echo "6- Update Table Content"
    echo "7- Back to Main Menu"
    echo "8- Exit"
    echo ""
    read -r -p "Choose an option: " table_choice
    echo ""

     case $table_choice in
        1) ./tables/createTable.sh "$schemaName";;
        2) ./tables/listTables.sh "$schemaName" ;;
        3)  selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/selectFromTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        4)selectedTable=$(./tables/listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/deleteTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        5) ./tables/listTables.sh "$schemaName"
        selectedTable=$(./tables/listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/insertIntoTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        6) selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/updateTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        7) source ./mainMenu.sh && main_menu ;;
        8) cd ..; return 0 ;;

        *) echo "Invalid option"; table_menu;;
    esac
}
table_menu
