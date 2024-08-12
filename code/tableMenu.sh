#!/bin/bash
source ./utils/helperFunctions.sh
# source ./tables/listTables.sh
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
    echo "3- Select From Table"
    echo "4- Delete from Table"
    echo "5- Insert Into Table"
    echo "6- Update Table Content"
    echo "7- Drop Table"
    echo "8- Back to Main Menu"
    echo "9- Exit"
    echo ""
    read -r -p "Choose an option: " table_choice
    echo ""

       case $table_choice in
        1) source ./tables/createTable.sh "$schemaName";;
        2) listTablesMenu "$schemaName" ;;
        3) source ./tables/listTables.sh "$schemaName"
           source ./tables/selectFromTable.sh "$schemaName" "$selectedTable" 
        ;;
        4) echo "***** Select the Table you Want to Delete from, from the Below List *****"
           echo ""
           source ./tables/listTables.sh "$schemaName"
           source ./tables/deleteFromTable.sh "$schemaName" "$selectedTable" 
        ;;
        5)  source ./tables/listTables.sh "$schemaName"
            source ./tables/insertIntoTable.sh "$schemaName" "$selectedTable" 
        ;;
        6) source ./tables/listTables.sh "$schemaName"
            source ./tables/updateTable.sh "$schemaName" "$selectedTable" 
        ;;
        7) echo "***** Select the Table you Want to DROP from the Below List *****"
           echo ""
           source ./tables/listTables.sh "$schemaName"
           source ./tables/dropTable.sh "$schemaName" "$selectedTable" 

        ;; 
        8) source ./mainMenu.sh && main_menu ;;
        9) exit 0 ;;

        *) echo "Invalid option"; table_menu;;
    esac
}
table_menu
