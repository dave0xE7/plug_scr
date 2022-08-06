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
