#!/bin/bash

source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

listDatabases() {

    echo "***** Listing Schemas *****"
    echo ""
    echo "The Available Schemas Are:"
    echo ""

    counter=1

    for schema in "$DB_ROOT"/*

    do

        if [[ -d "$schema" ]]

        then

            echo  "$counter- $(basename "$schema")"
            ((counter++))
        fi

    done

}

listDatabases
echo ""