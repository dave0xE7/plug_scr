#!/usr/bin/env bash

PLUG_GIT_REPO='https://github.com/dave0xE7/plug_scr/'

SCRIPT_NAME=""
case "${0}" in
    "bash" | "/bin/bash")
        # ShowVariable 0
        # ShowVariable BASH_SOURCE
        if [[ -n "${BASH_SOURCE}" ]]; then
            export SCRIPT_NAME="${BASH_SOURCE}"
        fi
        ;;
    *)
        # echo "default (none of above)"
        export SCRIPT_NAME="${0}"
        ;;
    esac

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
    # creating destination folder
    if (mkdir -vp $PLUG_DEST) ; then
        # cloning from github repo into destination folder
        git clone $PLUG_GIT_REPO $PLUG_DEST
        # starting setup process and then exit current shell
        bash $PLUG_DEST/main.sh setup
        exit 0;
    else
        echo "error: could not create destination folder $PLUG_DEST"
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

function Setup () {
    source $PLUG_DEST/lib/installation.sh
    echo "done"
}

function ShowHelpMessage () {
    echo "plug <options/commands>"
    echo ""
    echo "[options]"
    echo "  -u # unattended mode"
    echo ""
    echo "[commands]"
    echo "help   # shows this message"
    echo "info   # displays some info"
    echo "setup"
    echo "shell"
    echo "update"
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
        setup) 
        Setup
        shift # shift once since flags have no values
        ;;

        daemon) 
        source $PLUG_DEST/lib/daemon.sh ${1}
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
