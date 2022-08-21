#!/usr/bin/env bash

source common.sh

# cd /sys/devices
# for i in $(find * -maxdepth 0 -type d); do
#     subdirs=$(find $i -type d | wc -l);
#     subfiles=$(find $i -type f | wc -l);
#     echo "$i $subdirs $subfiles"
# done

# cd /sys/devices/
# for i in $(find * -type f ! -path '*power*'); do
#     echo "$i"
    
# done

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

#WalkDir /home/user/dev

FindLevelDirs() { find $1 -mindepth 1 -maxdepth 1 -type d; }
FindLevelFiles() { find $1 -mindepth 1 -maxdepth 1 -type f; }

WalkPath() {
    echo "WalkPath $1"
    for i in $(FindLevelDirs $1); do
        printf "\t$(basename $i) " 
        subdirs=$(FindLevelDirs $i | wc -l)
        subfiles=$(FindLevelFiles $i | wc -l)
        if [[ $subdirs > 1 ]]; then
            printf "$subdirs dirs "
        fi
        if [[ $subfiles > 1 ]]; then
            printf "$subfiles files "
        fi
        printf '\n'
    done
}

#WalkPath $HOME


WalkInit() {
    find $1 -type d ! -path '*/.git/*/*' > /tmp/back/dirs
    find $1 -type f ! -path '*/.git/*/*' > /tmp/back/files

    dirs=$(cat /tmp/back/dirs | wc -l)
    files=$(cat /tmp/back/files | wc -l)

    echo "found $dirs dirs and $files files in $1"
}

WalkChanges() {
    last=$(( ($(date -r /tmp/back/files +%s) - $(date +%s)) / 60 ))
    echo "last find $last"
    find $1 -type f ! -path '*/.git/*/*' -cmin $last > /tmp/back/changes

    for i in $(cat /tmp/back/changes); do
        echo "$i"
        md5sum $i
        grep $i /tmp/back/hashes
    done
}

if ! [ -f /tmp/back/files ]; then
    WalkInit $HOME/dev
else
    WalkChanges $HOME/dev
fi

if ! [ -f /tmp/back/hashes ]; then
    sumfiles=$(cat /tmp/back/files | wc -l)
    echo "hashing $sumfiles files"
    j=0
    for i in $(cat /tmp/back/files); do
        md5sum $i >> /tmp/back/hashes
        j=$[j+1];
        echo "$sumfiles/$j"
    done

fi