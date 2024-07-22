#!/bin/bash
# export LC_COLLATE=C

source ./helperFunctions.sh

# to make it case insensitive
shopt -s nocasematch

parseCommand(){
    command=$1
    shift
    
    # echo "$@"

    case $command in
        CREATE)
            if [[ $1 == "SCHEMA" ]]; then
                shift
                ./databases/createSchema.sh "$@"
            elif [[ $1 == "TABLE" ]]; then
                ./createTable.sh "${@:2}"
            else
                printError "Invalid Create Command "
            fi
        ;;
        INSERT)
            
        ;;
        SELECT)
        ;;
        UPDATE)
        ;;
        DELETE)
        ;;
        *)
        ;;
    esac
}
if [[ $# -eq 0 ]]
then
    printError "No Command Provided"
    exit 1
fi

parseCommand "$@"

createTableParse(){
# CREATE TABLE : t1
# CREATE TABLE : lookup (id INT, name STRING)
# CREATE TABLE Persons (
#     ID int NOT NULL,
#     LastName String NOT NULL,
#     FirstName String,
#     Age int,
#     PRIMARY KEY (ID)
# );
# CREATE TABLE Persons (
#     ID int NOT NULL,
#     LastName String NOT NULL,
#     FirstName String,
#     Age int,
#       CONSTRAINT PK_Person PRIMARY KEY (ID,LastName)
# );
# logic => after getting the name make a dilemeter ',' and check after dilemeter for the name then type and then search for PK statement if not stated by default the first is pk and print message for such case
 local tableName=$1
 if [[ $# -gt 1 ]]
 then
    shift

    local tableFields=$*;
 fi
}