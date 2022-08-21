#!/usr/bin/env bash

PLUG_GIT_REPO='https://github.com/dave0xE7/plug_scr/'

if [ ! -n "$PLUG_DEST" ]; then
    PLUG_DEST="$HOME/.plug"
else
    echo "PLUG_DEST was already declared PLUG_DEST=$PLUG_DEST"
fi

if [ -d "$PLUG_DEST" ]; then
    if [ -f "$PLUG_DEST/config.sh" ]; then
        echo "plug found"
        #echo "hostid=$(cat $PLUG_DEST/hostid)"
    fi
else
    if (mkdir -vp $PLUG_DEST) ; then
        git clone $PLUG_GIT_REPO $PLUG_DEST
    fi
fi

source $PLUG_DEST/lib/common.sh
source $PLUG_DEST/lib/info.sh

if [ ! -f "$PLUG_DEST/config.sh" ]; then
    echo "setup='$(date)'" > "$PLUG_DEST/config.sh"
    PLUG_ID=$(GetSystemInfo | JsonPipe | Hash)
    echo "PLUG_ID='$PLUG_ID'" >> "$PLUG_DEST/config.sh"
fi

LoadConfigFile "$PLUG_DEST/config.sh"

function Installation () {
    echo "done"
}

function Update() {
    git -C $PLUG_DEST pull
}

function Info () {
    echo "plug info"
    echo ""
    echo ""
    ShowVariable PLUG_DEST
    ShowVariable PLUG_ID
    echo ""
}

function Shell () {
    
    cd $PLUG_DEST
    bash --noprofile --rcfile $PLUG_DEST/lib/bashrc
}

function ShowHelpMessage () {
    echo "plug <options/commands>"
    echo ""
    echo "[options]"
    echo "  -u # unattended mode"
    echo ""
    echo "plug help # shows this message"
    echo ""
}

POSITIONAL=()
while (( $# > 0 )); do
    case "${1}" in
        -f|--flag)
        echo flag: "${1}"
        shift # shift once since flags have no values
        ;;
        help|-h|--help)
        ShowHelpMessage
        shift # shift once since flags have no values
        ;;
        update)
        Update
        shift # shift once since flags have no values
        ;;

        shell)
        Shell
        shift # shift once since flags have no values
        ;;
        info) 
        Info
        shift # shift once since flags have no values
        ;;
        -s|--switch)
        numOfArgs=1 # number of switch arguments
        if (( $# < numOfArgs + 1 )); then
            shift $#
        else
            echo "switch: ${1} with value: ${2}"
            shift $((numOfArgs + 1)) # shift 'numOfArgs + 1' to bypass switch and its value
        fi
        ;;
        *) # unknown flag/switch
        POSITIONAL+=("${1}")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional params
