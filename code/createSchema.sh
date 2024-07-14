#!/bin/bash

source helperFunctions.sh


if [[ $# -ne 1 ]]
then
    printError "$0 is not valid schema name"
    exit 1
fi

schemaName=$1

if [[ -d "$schemaName" ]]
then
    printError "$schemaName already exists"
    exit 1
fi

mkdir "$schemaName"
echo "Schema $schemaName created"
