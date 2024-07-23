#!/bin/bash
source ./utils/helperFunctions.sh
DB_ROOT="../mySchemas"
selectFromTable() {
    local schema="$1"
    local table="$2"
    local column="$3"
    local value="$4"
    
    awk -F'|' -v col="$column" -v val="$value" '
    function trim(str) {
        gsub(/^[ \t]+|[ \t]+$/, "", str)
        return str
    }
    NR == 1 {
        for (i = 1; i <= NF; i++) {
            cols[i] = trim($i)
        }
        print $0  # Print the header
    }
    NR > 3 {
        for (i = 1; i <= NF; i++) {
            if (cols[i] == trim(col) && trim($i) == trim(val)) {
                print $0
            }
        }
    }' "$DB_ROOT/$schema/$table"
}


# c[1] = "name"
# c[2] = "age"
# idx[c[i]]
# idx["name"] = 2
# idx["age"] = 3
returnAllColData() {
    local schema="$1"
    local table="$2"
    shift 2
    local columns=("$@")

    awk -F'|' -v cols="${columns[*]}" '
    function trim(str) {
        gsub(/^[ \t]+|[ \t]+$/, "", str)
        return str
    }
    BEGIN { 
        split(cols, c, " ")
        for (j in c) {
            c[j] = trim(c[j])
        }
    }
    NR == 1 { 
        for (i = 1; i <= NF; i++) {
            colname[trim($i)] = i
        }
        header = ""
        for (j in c) {
            if (header == "") {
                header = c[j]
            } else {
                header = header "|" c[j]
            }
        }
        print header
    }
    NR > 3 {
        line = ""
        for (j in c) {
            col_idx = colname[c[j]]
            if (line == "") {
                line = $col_idx
            } else {
                line = line "|" $col_idx
            }
        }
        print line
    }' "$DB_ROOT/$schema/$table"
}


returnAllData() {
    local schema="$1"
    local table="$2"

    sed -n '1,1p' "$DB_ROOT/$schema/$table"
    sed -n '4,$p' "$DB_ROOT/$schema/$table"
}

extractColandRow() {
    local schema="$1"
    local table="$2.txt"
    echo "How do you want to fetch the table data?"
    echo "1- All table data"
    echo "2- Certain table column/s"
    echo "3- Select table row/s"
    echo "4- Back to Table Menu"
    read -r -p "Choose an option: " method

    case $method in
        1)
            returnAllData "$schema" "$table"
            ;;
        2)
            read -p "Enter the columns you want, separated by space: " -a columns
            for col in "${columns[@]}"; do
                checkColumnExistance "$schema" "$table" "$col"
                if [[ $? -ne 0 ]]; then
                    printError "Invalid column name: $col"
                    return 1
                fi
            done
            returnAllColData "$schema" "$table" "${columns[@]}"
            ;;
        3)
            read -p "Enter the column name that has the value you want to match: " matchCol
            checkColumnExistance "$schema" "$table" "$matchCol"
            if [[ $? -ne 0 ]]; then
                printError "Invalid column name: $matchCol"
                return 1
            fi
            read -r -p "Enter the value you want to match: " value
            selectFromTable "$schema" "$table" "$matchCol" "$value"
            ;;
        4) return 1
            ;;
        *)
            echo "Invalid command"
            ;;
    esac
}
while true
do
    printf "\n"
    echo "***** You Are Now Selecting From Table $2 *****"
    printf "\n"
    extractColandRow $1 $2
    if [[ $? -eq 1 ]]; then
        ./tableMenu.sh $1
    fi
done