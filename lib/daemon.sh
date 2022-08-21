#!/usr/bin/env bash

if [ ! -n "$PLUG_DEST" ]; then
    echo "PLUG_DEST not set"
    exit 1
fi

export PLUG_DAEMON_INTERVAL=10

export PLUG_DAEMON_LOCK_FILE=daemon.pid
export PLUG_DAEMON_LOG_FILE=daemon.log

function Worker () {
    echo "daemon started"

    echo $$ > $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE

    while true; do

        echo "iteration"
        notify-send 'asdf'
        sleep 10

    done

    echo "daemon stopped"
}

function Daemon_Run() {
    echo "Daemon_Run"
    # set +x
    # Daemon_Main &>/dev/null &
    # Daemon_Main &>$PLUG_DEST/$PLUG_DAEMON_LOG_FILE &
    bash $BASH_SOURCE worker &>/dev/null &
    # set -x
    # bgpid=$!
    # echo $bgpid >$PLUG_DEST/$PLUG_DAEMON_LOCK_FILE
    # echo "bgpid=$bgpid"
}

function Daemon_IsRunning() {
    if [ -f $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE ]; then
        if pgrep -F $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE >/dev/null; then
            return 0
        fi
    fi
    return 1
}
function Daemon_Status() {
    echo "Daemon-Status: "
    if [ -f $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE ]; then
        lastPid=$(cat $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE)
        echo "lastPid=$lastPid"

        if Daemon_IsRunning; then
            echo "daemon is running"

            ps -u -f --forest --ppid $lastPid
        else
            echo "daemon is not running"
        fi
    else
        echo "no pidfile found. daemon not running"
    fi
}

function Daemon_Stop() {
    if Daemon_IsRunning; then
        echo "stopping the daemon"
        kill $(cat $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE)
    fi
}

function Daemon_Start() {
    echo "Daemon_Start"
    # echo "fgpid=$fgpid"

    if Daemon_IsRunning; then
        echo "daemon already running"
    else
        echo "daemon not running"
        Daemon_Run
    fi

    # echo "main done"
    # ps -u -f --forest --ppid $fgpid
}


POSITIONAL=()
while (( $# > 0 )); do
    case "${1}" in
        start) Daemon_Start; shift;;
        stop) Daemon_Stop; shift;;
        status) Daemon_Status; shift;;
        worker) Worker; shift;;
        
        *) # unknown flag/switch
        POSITIONAL+=("${1}")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional params
