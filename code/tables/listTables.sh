#!/bin/bash
source ../utils/helperFunctions.sh

listTables(){
    local schemaName="$1"
    checkSchemaExistance "$schemaName"
    local tables=()
    local index=1


  echo "Tables in schema $schemaName:"
    for table in ../mySchemas/"$schemaName"/*.txt; do
        if [[ -f "$table" && "$table" != *"_meta.txt" ]]; then
            tables+=("$(basename "$table" .txt)")
            echo "$index. $(basename "$table" .txt)"
            index=$((index + 1))
        fi
    done
       if [[ ${#tables[@]} -eq 0 ]]; then
        printError "No tables found."
        return 1
    fi
    read -r -p "Enter the number of the table: " tableNumber
    if [[ $tableNumber -le 0 || $tableNumber -gt ${#tables[@]} ]]; then
        printError "Invalid selection."
        return 1
    fi
    selectedTable="${tables[$((tableNumber-1))]}"
    echo "$selectedTable"
    return 0
}
if [[ $# -ne 1 ]]; then
    printError "Schema name is not correct."
    exit 1
fi
listTables "$1"

