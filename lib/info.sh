#!/usr/bin/env bash


function GetSystemInfo () {
    hostname=$(hostname)
    arch=$(lscpu | grep 'Architecture' |awk '{print $2}' | head -n 1)
    cores=$(lscpu | grep 'CPU(s)' |awk '{print $2}' | head -n 1)
    cpuModel=$(lscpu | grep 'Model name' |cut -d ' ' -f 3- | sed -e 's/^[[:space:]]*//')
    cpuType=$(uname -p)
    # distroCodeName=$(lsb_release -c | awk '{print $2}')
    # distroName=$(lsb_release -i | awk '{print $3}')
    # distroVersion=$(lsb_release -r | awk '{print $2}')
    kernelName=$(uname -s)
    kernelRelease=$(uname -r)
    sysMemoryMemTotal=$(grep 'MemTotal' < /proc/meminfo | awk '{print $2}' | head -n 1)

    echo '{"systeminfo": {'
    echo '"hostname": "'${hostname}'",'
    echo '"arch": "'${arch}'",'
    echo '"cores": "'${cores}'",'
    echo '"cpuModel": "'${cpuModel}'",'
    echo '"cpuType": "'${cpuType}'",'
    # echo '"distroCodeName": "'${distroCodeName}'",'
    # echo '"distroName": "'${distroName}'",'
    # echo '"distroVersion": "'${distroVersion}'",'
    echo '"kernelName": "'${kernelName}'",'
    echo '"kernelRelease": "'${kernelRelease}'",'
    echo '"sysMemoryMemTotal": "'${sysMemoryMemTotal}'"'
    echo '}}'
}

function ListBlockDevices () {
    lsblk --json    
}

function GetIpAddresses () {
    ip -j addr
}
function GetIpRoutes () {
    ip -j route
}
function GetIpInfo () {
    curl -s ipinfo.io/json | jq -cM
}

# GetSystemInfo | jq
# ListBlockDevices | jq