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

    pkg update -y
    pkg install curl wget git jq openssh tor torsocks -y

    . $PLUG_DEST/lib/on_termux_initial_setup.sh

else

    if [[ $PATH == ?(*:)$HOME/.local/bin?(:*) ]]; then
        mkdir -vp $HOME/.local/bin
        ln -s $PLUG_DEST/main.sh $HOME/.local/bin/plug
    fi

    if [ -d "$HOME/.local" ]; then
        echo "directory \"$HOME/.local\" exists"
    fi

  if [ "$(command -v apt)" ]; then
    echo "command \"apt\" exists on system"
    sudo apt update -y
    sudo apt install -y curl wget git jq tor openssh-server
  fi
  
    
    source $PLUG_DEST/lib/install_systemd.sh

fi
