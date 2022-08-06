#!/usr/bin/env bash

PLUG=$HOME/.plug
mkdir -vp $PLUG

. info.sh
. common.sh

if ! [ -f $PLUG/id ]; then
    PLUG_ID=$(GetSystemInfo | JsonPipe | Hash)
    echo $PLUG_ID > $PLUG/id
else
    PLUG_ID=$(cat $PLUG/id)
fi

echo $PLUG
echo $PLUG_ID


if ! [ -d $PLUG/plug_data ]; then
    cd $PLUG
    git clone git@github.com:dave0xE7/plug_data.git
fi

cd $PLUG/plug_data
mkdir -vp hosts
mkdir -vp hosts/$PLUG_ID
ListBlockDevices | JsonPipe > hosts/$PLUG_ID/blockdevices
GetSystemInfo | JsonPipe > hosts/$PLUG_ID/systeminfo

git add hosts/$PLUG_ID
git commit -m "added host $PLUG_ID"
git push