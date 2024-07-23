#!/bin/bash

source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

dbName="$schemaName"
tableName="$selectedTable"
tableFile="$DB_ROOT/$dbName/$tableName.txt"

echo ""
echo "***** Are you Sure that you Want to Drop '$tableName' Table in '$dbName' Schema?"
echo ""
echo "1- Yes"
echo "2- No"
echo ""
read -r -p "Select an Option: " doption

case $doption in

    1) rm $tableFile
       echo ""
       sleep 1
       echo "'$tableName' Table is Successfully Removed from '$dbName' Schema!"
       echo ""
       echo "Going Back to Table Menu"
       echo ""
       sleep 2
       source ./tableMenu.sh "$dbName"
    ;;

    2) echo ""
       echo "Going Back to Table Menu"
       echo ""
       sleep 1
       source ./tableMenu.sh "$dbName"
    ;;

esac