#!/usr/bin/env bash

source common.sh


function WalkDir () {
    echo "WalkDir $1"

    lastPath=$(pwd)
    cd $1

    OUTPUT=$(mktemp walk-XXXX -t)

    for i in $(find -type f); do 
        md5sum $i;
    done > $OUTPUT 
    
    
    local uniqs=$(cat $OUTPUT | sort | uniq -w 32 -u)
    local dupes="$(cat $OUTPUT | sort | uniq -w 32 -d)"

    for dupes in $(cat $OUTPUT | sort | uniq -d -c -w 32 | sort -r); do
        echo $dupes | NF 1
        echo "$dupes"
    done

    # for j in $(cat $OUTPUT | sort | uniq -w 32); do
    #     echo "$j"
    #     local hash=$(echo $j | NF 1)
    #     echo "$hash  $(echo $j | NF 2)"
    # done

    cd $lastPath
    echo $OUTPUT
    echo "done"
}

WalkDir /home/user/dev