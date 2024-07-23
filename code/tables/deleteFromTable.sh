#!/bin/bash

source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

dbName="$1"
tableName="$2"
tableFile="$DB_ROOT/$dbName/$tableName.txt"

if [[ ! -f "$tableFile" ]]
then
    printError "Table $tableName does not exist in schema $dbName."
    exit 1
fi

listRows() {
    echo ""
    echo "Rows in '$tableName' Table are: "
    awk 'NR == 1 {print $0}' "$tableFile"
    awk 'NR > 3 {print NR-3 ": " $0}' "$tableFile"
}
listRows

# Function to Delete by Row Number:

deleteByRowNumber() {

    listRows
    echo ""

    while true
    do
        read -r -p "Enter the Row Number to Delete: " rowNum
        if ! [[ "$rowNum" =~ ^[0-9]+$ ]] || [[ "$rowNum" -le 0 ]]
        then
            printError "Invalid Row Number"
        else
            break
        fi
    done

    lineNum=$((rowNum + 3))
    totalLines=$(wc -l < "$tableFile")

    if [[ "$lineNum" -gt "$totalLines" ]]
    then
        printError "The Selected Row is Out of Range!"
        exit 1
    fi

    sed -i "${lineNum}d" "$tableFile"
    echo ""
    echo "Row #$rowNum is Deleted from '$tableName' Table Successfully!"
}

deleteByCondition() {

    IFS=' | ' read -r -a colNames < <(head -n 1 "$tableFile")
    echo ""
    echo "The Columns Available in '$tableName' Table are:"
    echo ""

    for col in "${colNames[@]}"
    do
        echo "- $col"
    done

    while true
    do

        read -r -p "Enter the Column Name for the Condition: " colName
        echo ""
        if ! [[ " ${colNames[*]} " =~ " $colName " ]] 
        then
            printError "Invalid Column Name!"
        else
            break
        fi
    done

    read -r -p "Enter the Value to Match: " matchValue
    echo ""

    for i in "${!colNames[@]}"
    do
        if [[ "${colNames[$i]}" == "$colName" ]]
        then
            colIndex=$((i + 1))
            break
        fi
    done

    local countBefore=$(awk -F' \\| ' -v colIndex=$colIndex -v matchValue="$matchValue" '
    NR > 3 && $colIndex == matchValue {count++}
    END {print count}' "$tableFile")


    awk -F' \\| ' -v colIndex=$colIndex -v matchValue="$matchValue" 'NR <= 3 || $colIndex != matchValue' "$tableFile" > temp && mv temp "$tableFile"

    local countAfter=$(awk -F' \\| ' -v colIndex=$colIndex -v matchValue="$matchValue" '
    NR > 3 && $colIndex == matchValue {count++}
    END {print count}' "$tableFile")

    if (( countBefore > countAfter )); then
        echo "Rows matching condition '$colName = $matchValue' were deleted from '$tableFile' table."
    else
        echo "No rows matching condition '$colName = $matchValue' were found in '$tableFile' table."
    fi

    echo ""

}

echo ""
echo "***** Choose Deletion Method *****"
echo ""
echo "1- Delete by Row Number"
echo "2- Delete by Condition (WHERE Clause Simulation)"
echo ""
read -r -p "Select an Option: " methodOption
echo ""

case $methodOption in
    1) deleteByRowNumber ;;
    2) deleteByCondition ;;
    *) printError "Invalid option."; exit 1 ;;
esac

# Prompt user for next action
echo "1- Delete Another Row"
echo "2- Go Back to Table Menu"
echo "3- Go to Main Menu"
echo "4- Exit"
echo ""
read -r -p "Choose an option: " doption

case $doption in
    1)
        source ./tables/deleteFromTable.sh "$dbName" "$tableName"
    ;;
    2)
        source ./tableMenu.sh "$dbName"
    ;;
    3)
        source ./mainMenu.sh
    ;;
    4) 
        exit 0
    ;;
    *) 
        echo "Invalid Option!"; 
        source ./tableMenu.sh "$dbName"
    ;;
esac
