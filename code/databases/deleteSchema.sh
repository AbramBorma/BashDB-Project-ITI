#!/bin/bash

source ./utils/helperFunctions.sh

deleteSchema() {
    local schemaName="$1"
    
    if [[ ! -d "../mySchemas/$schemaName" ]]; then
        printError "Schema $schemaName does not exist"
        return 1
    fi

    rm -r "../mySchemas/$schemaName"
    echo "Schema $schemaName dropped"
    return 0
}

deleteSchemaMenu() {
    ./listSchemas.sh
    if [[ $? -ne 0 ]]; then
        return 1
    fi

    read -r -p "Enter the number of the schema you want to delete: " schemaNumber
    local schemas=()
    for schema in ../mySchemas/*; do
        if [[ -d "$schema" ]]; then
            schemas+=("$(basename "$schema")")
        fi
    done

    if [[ $schemaNumber -lt 1 || $schemaNumber -gt ${#schemas[@]} ]]; then
        printError "Invalid selection"
        return 1
    fi

    local selectedSchema="${schemas[$((schemaNumber - 1))]}"
    deleteSchema "$selectedSchema"
}

deleteSchemaMenu
