#!/bin/bash
source ./utils/helperFunctions.sh
source ./tables/listTables.sh

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
<<<<<<< HEAD
    echo "3- Select from Table"
    echo "4- Delete from Table"
=======
    echo "3- Select From Table"
    echo "4- Delete Entire Table"
>>>>>>> 370d633 (bug fixing')
    echo "5- Insert Into Table"
    echo "6- Update Table Content"
    echo "7- Drop Table"
    echo "8- Back to Main Menu"
    echo "9- Exit"
    echo ""
    read -r -p "Choose an option: " table_choice
    echo ""

       case $table_choice in
        1) ./tables/createTable.sh "$schemaName";;
<<<<<<< HEAD
        2) ./tables/listTables.sh "$schemaName" ;;
        3)  selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/selectFromTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        4) echo "***** Select the Table you Want to Delete from, from the Below List *****"
           echo ""
           source ./tables/listTables.sh "$schemaName"
           source ./tables/deleteFromTable.sh "$schemaName" "$selectedTable" 
        ;;
        5) source ./tables/listTables.sh "$schemaName"
           source ./tables/insertIntoTable.sh "$schemaName" "$selectedTable" 
        ;;
        6) selectedTable=$(./listTables.sh "$schemaName")
        if [[ $? -eq 0 ]]; then 
            ./tables/updateTable.sh "$schemaName" "$selectedTable" 
        fi
        ;;
        7) echo "***** Select the Table you Want to DROP from the Below List *****"
           echo ""
           source ./tables/listTables.sh "$schemaName"
           source ./tables/dropTable.sh "$schemaName" "$selectedTable" 

        ;; 
        8) source ./mainMenu.sh && main_menu ;;
        9) exit 0 ;;

=======
        2) listTables "$schemaName";;
        3) listTables "$schemaName" | tail -n 1 > temp_output.txt
        result=$(<temp_output.txt)
        rm temp_output.txt
    ./tables/selectFromTable.sh "$schemaName" "$result"
    ;;
        4) selectedTable=$(listTables "$schemaName")
           if [[ $? -eq 0 && -n "$selectedTable" ]]; then 
               ./tables/deleteTable.sh "$schemaName" "$selectedTable"
           fi
           ;;
        5) selectedTable=$(listTables "$schemaName")
           if [[ $? -eq 0 && -n "$selectedTable" ]]; then 
               ./tables/insertIntoTable.sh "$schemaName" "$selectedTable"
           fi
           ;;
        6) selectedTable=$(listTables "$schemaName")
           if [[ $? -eq 0 && -n "$selectedTable" ]]; then 
               ./tables/updateTable.sh "$schemaName" "$selectedTable"
           fi
           ;;
        7) source ./mainMenu.sh && main_menu;;
        8) cd ..; return 0;;
>>>>>>> 370d633 (bug fixing')
        *) echo "Invalid option"; table_menu;;
    esac
}
table_menu
