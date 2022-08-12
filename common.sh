#!/usr/bin/env bash


function JsonPipe () {
    jq  -cM
}

function Hash () {
    md5sum - | awk -F' ' '{print $1}'
}


function NF () {
    eval "awk -F' ' '{print \$$1}'"
}

Timestamp () { date +%s; }

function xsleep () {
    echo "xsleep $1"
    for((i=0;i<$1;i++)); do
        printf "="
        #echo "${i}"
        sleep 1
    done
    
}



