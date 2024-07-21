#!/bin/bash

source ./utils/helperFunctions.sh

DB_ROOT="../mySchemas"

echo "$dbName"

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

    echo "Table Name Validated: $tableName"

    # Continue with the rest of the logic
}

createTable "$1"


createTable










































# CREATE TABLE t1
# CREATE TABLE lookup (id INT, name STRING)

# read -r -p "Enter the table name: " tableName

# if [[ $# -lt 2 ]]
# then
#     printError "$0 i need to look up on the error messages"
#     exit 1
# fi

# schemaName=$1
# tableName=$2
# shift 2

# # columns=$@ here is says assigning array into string --need more search
# columns=$*

# checkSchemaExistance "$schemaName" || exit 1

# tablePath="$schemaName/$tableName.txt"
# metaPath="$schemaName/${tableName}_meta.txt"

# if [ -f "$tablePath" ] 
# then
#     printError "Table $tableName already exists in schema $schemaName"
#     exit 1
# fi

# touch "$tablePath"
# echo "${columns[*]}" | tr ' ' ',' > "$metaPath"
# echo "Table $tableName created in $schemaName"