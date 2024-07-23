#!/bin/bash

source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

validateInsertion() {

    local value="$1"
    local type="$2"
    local colName="$3"

    case $type in
        "INT") 
                if ! [[ "$value" =~ ^[0-9]+$ ]]
                then
                    printError "Invalid input for $colName. Expected an integer."
                    return 1
                fi
        ;;

        "STRING")
                if [[ -z "$value" || "$value" =~ \  || "$value" =~ ^[0-9]+$ ]]
                then
                    printError "Invalid input for $colName. Expected a non-empty string without spaces."
                    return 1
                fi
        ;;

        *)
                printError "Unknown type $type for column $colName."
                return 1
        ;;
    esac
    return 0
}

dbName="$schemaName"
tableName="$selectedTable"
tableFile="$DB_ROOT/$dbName/$tableName.txt"

insert_into_table() {


    local dbName="$1"
    local tableName="$2"
    local tableFile="$DB_ROOT/$dbName/$tableName.txt"

    if [[ ! -f "$tableFile" ]]; then
        printError "Table $tableName does not exist in schema $dbName."
        return 1
    fi

    IFS=' | ' read -r -a colNames < <(head -n 1 "$tableFile")
    IFS=' | ' read -r -a colTypes < <(head -n 2 "$tableFile" | tail -n 1)
    IFS=' | ' read -r -a colPKs < <(head -n 3 "$tableFile" | tail -n 1)

    # Find the maximum length of any column name/type/pk to format the output
    maxLen=0
    for col in "${colNames[@]}" "${colTypes[@]}" "${colPKs[@]}"; do
        len=${#col}
        if (( len > maxLen )); then
            maxLen=$len
        fi
    done

    format="%-${maxLen}s | "

    echo ""
    echo "***** Insert Into '$tableName' Table *****"
    echo ""

    while true
    do
        read -r -p "Enter the Number of Rows you Want to Insert: " numRows
        echo ""

        if [[ ! "$numRows" =~ ^[0-9]+$ || "$numRows" -le 0 ]]
        then
            printError "Please enter a valid number of rows."
        else
            break
        fi
    done

    for ((row = 1; row <= numRows; row++))
    do
        echo "Inserting row #$row of $numRows..."
        echo ""
        local values=()

        for ((i = 0; i < ${#colNames[@]}; i++))
        do
            colName=${colNames[i]}
            colType=${colTypes[i]}
            colPK=${colPKs[i]}

            while true
            do
                read -r -p "Enter the value for $colName with type ($colType): " value

                if [[ -z $value ]]
                then
                    printError "Value of $colName Can Not Be Empty"
                    continue
                fi

                validateInsertion "$value" "$colType" "$colName"
                if [[ $? -ne 0 ]]
                then
                    continue
                fi

                if [[ "$colPK" == "PK" ]]
                then
                    if grep -q "^$(printf "$format" "$value")" "$tableFile"
                    then
                        printError "Value of $colName Must be Unique as It is a Primary Key."
                        continue
                    fi
                fi

                values+=("$value")
                break
            done
        done

        # Insert the values to the tableFile
        {
            for value in "${values[@]}"; do
                printf "$format" "$value"
            done
            printf '\n'
        } >> "$tableFile"
    done
    
    echo ""
    echo "Data Inserted into Table $tableName Succesfully!"
    echo ""
    echo "***** What Else Do you Want to Do? *****"
    echo ""

    echo "1- Insert More Records"
    echo "2- Go Back to Table Menu"
    echo "3- Go to Main Menu"
    echo "4- Exit"
    read -r -p "Choose an option: " ioption

    case $ioption in
        1) ./tables/insertIntoTable.sh "$dbName" "$tableName";;
        2) ./tableMenu.sh "$dbName";;
        3) ./mainMenu.sh;;
        4) exit 0;;
        *) echo "Invalid Option!";;
    esac
}

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <schemaName> <tableName>"
    exit 1
fi

insert_into_table "$1" "$2"

export dbName
export tableName