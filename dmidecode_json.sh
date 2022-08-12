#!/bin/bash

# via http://git.savannah.nongnu.org/cgit/dmidecode.git/tree/dmiopt.c#n142
DMI_STRINGS="
    bios-vendor
    bios-version
    bios-release-date
    system-manufacturer
    system-product-name
    system-version
    system-serial-number
    system-uuid
    baseboard-manufacturer
    baseboard-product-name
    baseboard-version
    baseboard-serial-number
    baseboard-asset-tag
    chassis-manufacturer
    chassis-type
    chassis-version
    chassis-serial-number
    chassis-asset-tag
    processor-family
    processor-manufacturer
    processor-version
    processor-frequency
"

COMMAND=(
    "jq"
    "-n"
)
OUTPUT_DESC="{"
for key in $DMI_STRINGS; do
    _key=$(echo "$key" | sed 's/-/_/g') 
    novalue=0
    value="$(dmidecode "$@" -s $key)" || novalue=1
    if [ $novalue -eq 1 ]; then
        COMMAND+=(
            "--argjson"
            "$_key"
            "null"
        )
    else
        COMMAND+=(
            "--arg"
            "$_key"
            "$value"
        )
    fi
    OUTPUT_DESC="$OUTPUT_DESC \$$_key,"
done
OUTPUT_DESC="$OUTPUT_DESC }"
"${COMMAND[@]}" "$OUTPUT_DESC"
