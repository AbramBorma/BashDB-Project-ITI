#!/bin/bash

printError() {
    echo "Error: $1" &> 2
}
checkSchemaExistance(){
    if [[ ! -d  "$1" ]]
    then
        printError "Schema $! doesn't exist"
        return 1
    fi 
    return 0
}
checkTableExistance(){
    if [[ ! -f "$1/$2.txt" ]]
    then 
        print_error "Table $2 does not exist in schema '$1'"
        return 1
    fi
    return 0
}
