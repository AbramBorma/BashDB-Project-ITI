#!/bin/bash

source ./utils/helperFunctions.sh

DB_ROOT="../mySchemas"

echo "***** Create Tables in Schema: $dbName *****"
echo ""

createTable() {

    local tableName
    local numColumns
    local colNames=()
    local colTypes=()
    local colPKs=()
    local isPrimaryKey

    # Validation of table Name:
    while true
    do
        read -r -p "Enter the Table Name: " tableName
        echo ""

        if [[ -z "$tableName" ]]
        then
            printError "Table Name Can Not Be Empty."

        elif [[ "$tableName" =~ ^[0-9]+$ ]]
        then
            printError "Table Name Can Not Be a Number."

        elif [[ "$tableName" =~ \  ]]
        then
            printError "Table Name Must Be One Word Only."

        elif [[ -f "$DB_ROOT/$dbName/$tableName.txt" ]]
        then
            printError "Table Name Already Exists in this Schema."

        else
            break

        fi

    done

    echo "***** Your Table Name is: $tableName *****"
    echo ""

    while true
    do
        read -r -p "Enter the Number of Columns: " numCols

        if [[ -z "$numCols" ]]
        then
            printError "Number of columns cannot be empty."

        elif ! [[ "$numCols" =~ ^[0-9]+$ ]]
        then
            printError "Number of columns must be an integer."

        elif [[ "$numCols" -le 1 ]]
        then
            printError "Number of columns must be greater than zero."

        else
            break

        fi
    done

    echo "***** You Selected the Number of Columns to be: $numCols *****"
    echo ""

    allowedTypes=("INT" "STRING")

    for ((i = 1; i <= numCols; i++))
    do

        while true
        do
            read -r -p "Enter the Name of Column $i: " colName

            if [[ -z "$colName" ]]
            then
                printError "Column Name Can Not Be Empty."

            elif [[ "$colName" =~ \  ]]
            then
                printError "Column Name Must Be One Word Only."

            elif [[ "$tableName" =~ ^[0-9]+$ ]]
            then
                printError "Column Name Can Not Be a Number."
            else
                duplicate=false
                for existingColName in "${colNames[@]}"; do
                    if [[ "$colName" == "$existingColName" ]]; then
                        duplicate=true
                        break
                    fi
                done
                if [[ "$duplicate" == true ]]; then
                    printError "Column Name Must Be Unique."
                else
                    break
                fi
            fi
        done

        while true
        do
            read -r -p "Enter the Type of Column $i (INT, STRING): " colType

            colType="${colType^^}"

            if [[ " ${allowedTypes[*]} " =~ " $colType " ]]
            then
                break
            
            else
                printError "Invalid Column Type. Allowed types are: ${allowedTypes[*]}"
            
            fi
        done

        while true
        do
            read -r -p "Is column $i a primary key? (y/n): " isPrimaryKey

            if [[ "$isPrimaryKey" == "y" || "$isPrimaryKey" == "Y" ]]
            then
                colPKs+=("PK")
                break
            
            elif [[ "$isPrimaryKey" == "n" || "$isPrimaryKey" == "N" ]]
            then
                colPKs+=("")
                break

            else
                printError "Please Enter 'y' or 'n': "

            fi
        done

        colNames+=("$colName")
        colTypes+=("$colType")

    done

    # Save table structure to file with ' | ' delimiter
    tableFile="$DB_ROOT/$dbName/$tableName.txt"

    # Find the maximum length of any column name/type/pk to format the output
    maxLen=0
    for col in "${colNames[@]}" "${colTypes[@]}" "${colPKs[@]}"; do
        len=${#col}
        if (( len > maxLen )); then
            maxLen=$len
        fi
    done

    format="%-${maxLen}s | %-${maxLen}s | %-${maxLen}s\n"

    {
        printf "$format" "${colNames[@]}"
        printf "$format" "${colTypes[@]}"
        printf "$format" "${colPKs[@]}"
    } > "$tableFile"

    echo ""
    echo "Table $tableName created with columns saved in $tableFile."
    echo "$dbName"
    echo "$tableName"
    afterTableCreation "$dbName" "$tableName"
}

afterTableCreation() {
    local dbName="$1"
    local tableName="$2"

    while true
    do
        echo ""
        echo "***** How Do You Want to Manipulate $tableName Table? *****"
        echo ""
        echo "1- Insert Into Table"
        echo "2- Drop Table"
        echo "3- Go Back to Table Menu"
        echo "4- Exit"
        echo ""
        read -r -p "Choose an Option: " choice
        echo ""

        case $choice in 
            1) source ./tables/insertIntoTable.sh "$dbName" "$tableName" ;;
            2) source ./tables/dropTable.sh "$dbName" "$tableName" ;;
            3) source ./tableMenu.sh "$dbName" ;;
            4) exit 0 ;;
            *) echo "Invalid option"; afterTableCreation;;
        esac
    done
}

createTable "$1"
export dbName
export tableName