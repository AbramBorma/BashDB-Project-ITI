#!/bin/bash

source ./utils/helperFunctions.sh

# Start Update from Abram
listDatabases() {
    DB_ROOT="../mySchemas"
    echo "The Available Schemas Are:"
    for schema in "$DB_ROOT"/*; do
        if [[ -d "$schema" ]]; then
            echo "$(basename "$schema")"
        fi
    done
}

listDatabases
# End Update from Abram

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

    # removed the listSchemas.sh call from here

    if [[ $? -ne 0 ]]; then
        return 1
    fi

    read -r -p "Enter the number of the schema you want to delete: " schemaNumber
    local schemas=()
    for schema in ../mySchemas/*; do
        if [[ -d "$schema" ]]; then
        #  The basename command strips the directory path.
            schemas+=("$(basename "$schema")")
        fi
    done

# ${#array[@]} gives the number of elements in an array.
    if [[ $schemaNumber -lt 1 || $schemaNumber -gt ${#schemas[@]} ]]; then
        printError "Invalid selection"
        return 1
    fi

    local selectedSchema="${schemas[$((schemaNumber - 1))]}"
    deleteSchema "$selectedSchema"
}

deleteSchemaMenu