#!/bin/bash

source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

listDatabases() {

    echo "The Available Schemas Are:"

    for schema in "$DB_ROOT"/*

    do

        if [[ -d "$schema" ]]

        then

            echo  "$(basename "$schema")"
        fi

    done

}

listDatabases

cd ../code

echo "*****************************"

navigationMenu