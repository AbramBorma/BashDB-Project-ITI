#!/bin/bash
source ./utils/helperFunctions

updateTableContent() {
    local schema="$1"
    local table="$2"
    local matchColumn="$3"
    local matchValue="$4"
    shift 4
    local columns=("$@")

    local tableFile="$DB_ROOT/$schema/$table"
    local header
    local dataTypes
    local pkConstraints
    local tmpFile

    tmpFile=$(mktemp)
    header=$(head -n 1 "$tableFile")
    dataTypes=$(sed -n '2p' "$tableFile")
    pkConstraints=$(sed -n '3p' "$tableFile")
}