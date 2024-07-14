#!/bin/bash
# export LC_COLLATE=C

source ./helperFunctions.sh

# to make it case insensitive
shopt -s nocasematch

parseCommand(){
    command=$1
    shift

    case $command in
        CREATE)
        # in schema case if empty it acts as its created but the system give me error  
        # incase of multpile args only ffirst one is created
            if [[ $1 == "SCHEMA" ]]; then
                ./createSchema.sh "$2"
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


# echo "Case-insensitive comparison example:"
# str1="apple"
# str2="Apple"

# if [[ "$str1" == "$str2" ]]; then
#   echo "Strings are equal (case-insensitive)"
# else
#   echo "Strings are not equal"
# fi
