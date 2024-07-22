#!/bin/bash
source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

source ./databases/listSchemas.sh listDatabases
echo "***** Select a Schema *****"
echo ""

while true
do

    read -r -p "Please Enter the Schema Name: " dbName
    echo ""

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

echo "Connecting to '$dbName' Schema..."

sleep 2

echo ""

export dbName