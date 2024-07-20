#!/bin/bash


printError() {
    echo "Error: $1" 
}
checkSchemaExistance(){
    if [[ ! -d  "$DB_ROOT/$1" ]]
    then
        printError "Schema $! doesn't exist"
        return 1
    fi 
    return 0
}
checkTableExistance(){
    if [[ ! -f "$1/$2.txt" ]]
    then 
        printError "Table $2 does not exist in schema '$1'"
        return 1
    fi
    return 0
}

isReservedKeyword() {
    local keywords=("select" "from" "where" "insert" "update" "delete" "create" "drop" "table" "database" "schema")
    for keyword in "${keywords[@]}"; do
        if [[ "$1" == "$keyword" ]]; then
            return 0
        fi
    done
    return 1
}

validateAndCorrectName() {
    local name="$1"
    name="${name,,}"  # Convert to lowercase
       
    if [[ -z "$name" ]]; then
        printError "Schema name cannot be empty"
        return 1
    fi

    if isReservedKeyword "$name"; then
        printError "$name is a reserved keyword"
        return 1
    fi

    if [[ ! "$name" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        local corrected_name="${name//[^a-z0-9_]/_}"
        echo "Incorrect name convention. We corrected it to $corrected_name"
        name="$corrected_name"
    fi

    echo "$name"
    return 0
}

navigationMenu () {

    echo "What do you want to do?"
    echo "1- Go to Schemas Menu."
    echo "2- Go to Tables Menu."
    echo "3 Exit"
    read -r -p "Choose an option: " option

    case $option in

        1) source ./mainMenu.sh && main_menu
    ;;
        2) source ./tableMenu.sh && table_menu
    ;;
        3) exit 0
    ;;
        *) echo "Invalid Option!"; navigationMenu
    ;;

    esac
    exit 0
}