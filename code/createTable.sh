#!/bin/bash

source helperFunctions.sh

# CREATE TABLE t1
# CREATE TABLE lookup (id INT, name STRING)

if [[ $# -lt 2 ]]
then
    printError "$0 i need to look up on the error messages"
    exit 1
fi

schemaName=$1
tableName=$2
shift 2

# columns=$@ here is says assigning array into string --need more search
columns=$*

checkSchemaExistance "$schemaName" || exit 1

tablePath="$schemaName/$tableName.txt"
metaPath="$schemaName/${tableName}_meta.txt"

if [ -f "$tablePath" ] 
then
    print_error "Table $tableName already exists in schema $schemaName"
    exit 1
fi

touch "$tablePath"
echo "${columns[*]}" | tr ' ' ',' > "$metaPath"
echo "Table $tableName created in $schemaName"