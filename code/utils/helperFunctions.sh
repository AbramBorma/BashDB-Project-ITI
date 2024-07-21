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

    # Remove any leading non-alphabetic characters
    # Parameter Expansion Syntax: 
    # ${parameter#pattern}

    name="${name#[^a-z]*}"

    if [[ ! "$name" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        local corrected_name="${name//[^a-z0-9_]/}"
        if [[ -z "$corrected_name" ]]; then
            printError "Schema name cannot be corrected to a valid name"
            return 1
        fi
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
checkColumnExistance() {
    local schema="$1"
    local table="$2"
    local column="$3"
    local header
    header=$(head -n 1 "$DB_ROOT/$schema/$table")
    if [[ -z "$header" ]]; then
        printError "The table header is empty or the table does not exist"
        return 1
    fi

    if [[ "$header" =~ (^|:)"$column"(:|$) ]]; then
        return 0
    else
        printError "Column '$column' doesn't exist in table '$table' within schema '$schema'"
        return 1
    fi
}

isInteger() {
    local value="$1"
    [[ "$value" =~ ^-?[0-9]+$ ]]
}

checkPrimaryKeyConstraint() {
    local schema="$1"
    local table="$2"
    local column="$3"
    local value="$4"
    local header
    local pkIndex

    header=$(head -n 3 "$DB_ROOT/$schema/$table")
    pkIndex=$(awk -F: '{ if ($3 == "pk") print NR }' <<< "$header")

    if [ "$pkIndex" -eq "$column" ]; then
        if grep -q -F "$value" <(awk -F: '{print $'"$column"'}' "$DB_ROOT/$schema/$table"); then
            printError "Primary key constraint violation: $value already exists"
            return 1
        fi
    fi
    return 0
}