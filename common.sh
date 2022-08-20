#!/usr/bin/env bash

_encrypt() { gpg --batch --passphrase $password -c; }
_decrypt() { gpg --batch --passphrase $password -d; }
_compress() { tar -cz $1; }
_decompress() { tar -xz -C $1; }

_hash() { sha256sum | awk -F' ' '{print $1}'; }

function JsonPipe() {
    jq -cM
}

function Hash() {
    md5sum - | awk -F' ' '{print $1}'
}

function NF() {
    eval "awk -F' ' '{print \$$1}'"
}

UptimeEpoch() { date --date="$(uptime -s)" +%s; }
UptimeMin() { echo $((($(date --date="$(uptime -s)" +%s) - $(date +%s)) / 60)); }

function xsleep() {
    echo "xsleep $1"
    for ((i = 0; i < $1; i++)); do
        printf "="
        #echo "${i}"
        sleep 1
    done

}

Timestamp() { date +%s }
DateFormat() { date +%Y-%m-%d }
TimeFormat() { date +%H:%M:%S }

join_arr() {
    local IFS="$1"
    shift
    echo "$*"
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
    return $(command -v $1 &>/dev/null)
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
    echo $1 | tee -a $PLUG_LOG_FILE
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

stderr() {
    echo "${*}" 2>&1
}
mktee() {
    file="${1}"
    content="${2}"

    if ! grep -qs "${content}" "${file}" 2>/dev/null; then
        printf '%s' "Append to ${file}: "
        printf '%s\n' "${content}" | tee -a "${file}"
    else
        stderr "${content} in ${file} exists"
    fi
}

mkcp() {
    from="${1}"
    to="${2}"

    mkdir -vp "${to}"
    cp -n "${from}" "${to}"
}

LoadConfigFile() {
    # CONFIG_PATH='unit.config'
    CONFIG_PATH=$1
    # commented lines, empty lines und lines of the from choose_ANYNAME='any.:Value' are valid
    CONFIG_SYNTAX="^\s*#|^\s*$|^[a-zA-Z_]+='[^']*'$"

    # check if the file contains something we don't want
    if egrep -q -v "${CONFIG_SYNTAX}" "$CONFIG_PATH"; then
        echo "Error parsing config file ${CONFIG_PATH}." >&2
        echo "The following lines in the configfile do not fit the syntax:" >&2
        egrep -vn "${CONFIG_SYNTAX}" "$CONFIG_PATH"
    fi
    # otherwise go on and source it:
    source ${CONFIG_PATH}
}
# LoadConfigFile $PLUG_DEST/unit.config
