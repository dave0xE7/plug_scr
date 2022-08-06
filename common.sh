#!/usr/bin/env bash


function JsonPipe () {
    jq  -cM
}

function Hash () {
    md5sum - | awk -F' ' '{print $1}'
}



