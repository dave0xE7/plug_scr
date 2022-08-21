#!/usr/bin/env bash

PLUG_GIT_REPO='https://github.com/dave0xE7/plug_scr/'

if [ ! -n "$PLUG_DEST" ]; then
    PLUG_DEST="$HOME/.plug"
else
    echo "PLUG_DEST was already declared PLUG_DEST=$PLUG_DEST"
fi

if [ -d "$PLUG_DEST" ]; then

    if [ -f "$PLUG_DEST/hostid" ]; then

        echo "hostid=$(cat $PLUG_DEST/hostid)"
    fi
else

    read a
    mkdir -vp $PLUG_DEST
    if ($?) ; then
        git clone $PLUG_GIT_REPO $PLUG_DEST
    fi
fi
