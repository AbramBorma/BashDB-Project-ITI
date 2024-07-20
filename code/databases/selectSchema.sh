#!/bin/bash

source ./utils/helperFunctions.sh
source ./tableMenu.sh

while true
do

    read -r -p "Please Enter the Schema Name: " dbName

    dbName="${dbName,,}"

    if [[ -z $dbName ]]

    then

        printError "No Schema Name is Provided"

    elif [[ "$dbName" =~ \  ]]

    then

        printError "Schema Name must be Composed of One Word Only"
        return 2

    else

        checkSchemaExistance "$DB_ROOT/$dbName"
        if [[ $? -eq 0 ]]; then

            break

        fi

    fi

done

echo "Connecting to schema: $dbName"

sleep 2

cd "$DB_ROOT/$dbName"



table_menu