#!/bin/bash

source helperFunctions.sh


if [[ $# -ne 1 ]]
then
    printError "$* is not valid schema name"
    exit 1
fi

schemaName=$(validateAndCorrectName "$1")
if [[ $? -ne 0 ]]; then
    exit 1
fi

if [[ -d "$schemaName" ]]
then
    printError "$schemaName already exists"
    exit 1
fi

mkdir "$schemaName"
echo "Schema $schemaName created"
