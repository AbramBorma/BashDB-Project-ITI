#!/bin/bash

source ./utils/helperFunctions.sh


if [[ $# -ne 1 ]]
then
    printError "$* is not valid schema name"
    exit 1
fi

validation=$(validateAndCorrectName "$1")
echo $validation
status=$?

if [[ $status -ne 0 ]]; then
    exit 1
fi
schemaName=$(echo "$validation" | tail -n 1)

if [[ -d "../mySchemas/$schemaName" ]]
then
    printError "$schemaName already exists"
    exit 1
fi

mkdir "../mySchemas/$schemaName"
echo "Schema $schemaName created"
