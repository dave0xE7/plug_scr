#!/usr/bin/env bash


if (( $(id -u) != 0 )); then
    echo "I'm not root"
    exit 1
fi

if [ ! -n "$PLUG_DEST" ]; then
    echo "PLUG_DEST not set"
    exit 1
fi

echo "PLUG_DEST=$PLUG_DEST"




if [ -e /data/data/com.termux/files/home ]; then
    echo 'found termux'

    if [ ! -e /data/data/com.termux/files/usr/bin/plug ]; then
        ln -s $PLUG_DEST/main.sh /data/data/com.termux/files/usr/bin/plug
    fi

    . $PLUG_DEST/lib/on_termux_initial_setup.sh

else

    if [[ $PATH == ?(*:)$HOME/.local/bin?(:*) ]]; then
        mkdir -vp $HOME/.local/bin
        ln -s $PLUG_DEST/main.sh $HOME/.local/bin/plug
    fi

    if [ -d "$HOME/.local" ]; then
        echo "directory \"$HOME/.local\" exists"
    fi
    
    source $PLUG_DEST/lib/install_systemd.sh

fi
