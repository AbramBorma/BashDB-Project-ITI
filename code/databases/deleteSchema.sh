#!/bin/bash

source ./utils/helperFunctions.sh

echo "***** Deleting a Schema *****"
echo ""
# Start Update from Abram
listDatabases() {
    DB_ROOT="../mySchemas"
    echo "The Available Schemas Are:"
    echo ""
    counter=1
    for schema in "$DB_ROOT"/*; do
        if [[ -d "$schema" ]]; then
            echo "$counter- $(basename "$schema")"
            ((counter++))
        fi
    done
}

listDatabases
echo ""
# End Update from Abram

deleteSchema() {
    local schemaName="$1"
    checkSchemaExistance "$schemaName"
    rm -r "../mySchemas/$schemaName"
    echo ""
    echo "Schema $schemaName dropped"
    echo ""
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