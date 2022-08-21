#!/usr/bin/env bash

# pidfile=daemon.pid

# logfile=daemon.log


    export PLUG_DAEMON_INTERVAL=10

    export PLUG_DAEMON_LOCK_FILE=daemon.lock
    export PLUG_DAEMON_LOG_FILE=daemon.log

    export PLUG_DAEMON_INIT_EVAL="echo 'initeval';"
    export PLUG_DAEMON_LOOP_EVAL="echo 'loopeval'; "

function Daemon_Log() {
    echo "$1" >>$PLUG_DEST/$PLUG_DAEMON_LOG_FILE # arguments are accessible through $1, $2,...
}

function Daemon_Stopped() {
    Log_DT "daemon stopped"
}

function Daemon_Main() {
    Log_DT "daemon started"

    eval $PLUG_DAEMON_INIT_EVAL

    trap Daemon_Stopped EXIT

    # echo $$ >>$PLUG_DEST/$PLUG_DAEMON_LOCK_FILE
    # for ((i = 0; i < 10; i++)); do
    #     echo "${i}"
    #     sleep 1
    # done
    i=0
    while [ true ]; do
        # body
        set -x
        ((i++))
        Log_UT "${i} $$"
        eval $PLUG_DAEMON_LOOP_EVAL
        sleep $PLUG_DAEMON_INTERVAL
        set +x
    done
}

function Daemon_Run() {
    echo "Daemon_Run"
    # set +x
    # Daemon_Main &>/dev/null &
    # Daemon_Main &>$PLUG_DEST/$PLUG_DAEMON_LOG_FILE &
    bash $SCRIPT_NAME d &>$PLUG_DEST/$PLUG_DAEMON_LOG_FILE &
    # set -x
    bgpid=$!
    echo $bgpid >$PLUG_DEST/$PLUG_DAEMON_LOCK_FILE
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

function Daemon_Start() {
    echo "Daemon_Start"

    fgpid=$$
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

function Daemon_Stop() {
    if Daemon_IsRunning; then
        echo "stopping the daemon"
        kill $(cat $PLUG_DEST/$PLUG_DAEMON_LOCK_FILE)
    fi
}

function Daemon() {
    case "$1" in
    "start")
        Daemon_Start
        ;;
    "stop")
        Daemon_Stop
        ;;
    "restart")
        Daemon_Stop
        Daemon_Start
        ;;
    "status")
        Daemon_Status
        ;;
    *)
        Daemon_Start
        ;;
    esac
}
