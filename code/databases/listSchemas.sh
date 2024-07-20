#!/bin/bash

DB_ROOT="../mySchemas"

echo "The Available Schemas Are:"

for schema in "$DB_ROOT"/*

do

    if [[ -d "$schema" ]]

    then

        echo  "$(basename "$schema")"

    fi

done


