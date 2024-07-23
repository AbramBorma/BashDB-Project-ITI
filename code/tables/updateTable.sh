#!/bin/bash
source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"

update_table() {
    local schema="$1"
    local table="$2.txt"

    checkSchemaExistance "$schema" || exit 1
    checkTableExistance "$schema" "$table" || exit 1
    
    printf "\n"
    read -r -p "Enter the column name to match and update (or type \back to go to menu): " matchCol

    printf "\n"
    if [[ "$matchCol" == "\\back" ]]; then


        ./tableMenu.sh "$schema"
        return 1
    fi
    checkColumnExistance "$schema" "$table" "$matchCol" || exit 1

    read -r -p "Enter the value to match: " matchVal
    checkValueType "$schema" "$table" "$matchCol" "$matchVal" || exit 1

    read -r -p "Enter the new value: " newVal
    checkValueType "$schema" "$table" "$matchCol" "$newVal" || exit 1

    table_path="$DB_ROOT/$schema/$table"

    local header
    header=$(head -n 1 "$table_path")
    local match_index
    match_index=$(awk -F'|' -v col="$matchCol" '{
        for (i=1; i<=NF; i++) {
            gsub(/^[ \t]+|[ \t]+$/, "", $i);  # Trim spaces
            if ($i==col) print i
        }
    }' <<< "$header")

    if [ -z "$match_index" ]; then
        printError "Column index not found"
        exit 1
    fi
    local match_index_zero_based=$((match_index - 1))

    # Check for primary key constraint violation
    local pkRow
    pkRow=$(sed -n '3p' "$table_path")
    local pkFlag
    pkFlag=$(echo "$pkRow" | cut -d'|' -f"$match_index")

    if [[ "$pkFlag" == "PK" ]]; then
        if grep -q -F "$newVal" <(awk -F'|' '{print $'"$match_index"'}' "$table_path" | sed '1,3d'); then
            printError "Primary key constraint violation: $newVal already exists"
            return 1
        fi
    fi

    # Find the maximum length of any column name/type/pk to format the output
    IFS='|' read -r -a colNames <<< "$(head -n 1 "$table_path" | tr -d ' ')"
    IFS='|' read -r -a colTypes <<< "$(sed -n '2p' "$table_path" | tr -d ' ')"
    IFS='|' read -r -a colPKs <<< "$(sed -n '3p' "$table_path" | tr -d ' ')"

    local maxLen=0
    for col in "${colNames[@]}" "${colTypes[@]}" "${colPKs[@]}"; do
        len=${#col}
        if (( len > maxLen )); then
            maxLen=$len
        fi
    done

    local format="%-${maxLen}s | %-${maxLen}s | %-${maxLen}s\n"

    # Update the table with the new value
    local tmp_file
    tmp_file=$(mktemp)
    local update_count=0
    while IFS='|' read -r -a row; do
        for i in "${!row[@]}"; do
            row[$i]=$(echo "${row[$i]}" | sed 's/^[ \t]*//;s/[ \t]*$//')  # Trim spaces
        done
        if [ "${row[$match_index_zero_based]}" == "$matchVal" ]; then
            ((update_count++))
            row[$match_index_zero_based]=$newVal
        fi
        printf "$format" "${row[@]}" >> "$tmp_file"
    done < <(sed '1,3d' "$table_path")

    # Re-add header, types, PK rows with formatting
    {
        printf "$format" "${colNames[@]}"
        printf "$format" "${colTypes[@]}"
        printf "$format" "${colPKs[@]}"
        cat "$tmp_file"
    } > "${tmp_file}.tmp"

    mv "${tmp_file}.tmp" "$table_path"
    rm "$tmp_file"
    if [ "$update_count" -eq 0 ]; then
        echo "No rows were updated."
    else
        echo "$update_count row(s) affected."
    fi
}

if [ $# -ne 2 ]; then
    printError "Usage: $0 <schema_name> <table_name>"
    exit 1
fi

schemaName=$1
tableName=$2
while true
do
    printf "\n"
    echo "***** You Are Now Updating Table $tableName Content *****"
    printf "\n"
    update_table "$schemaName" "$tableName"
    if [[ $? -eq 1 ]]; then
        break
    fi
done
