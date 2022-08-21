

_RESET=$(tput sgr0)
_BOLD=$(tput bold)

_FgDarkGray=$(tput setaf 0) 	
_FgRed=$(tput setaf 1) 	
_FgGreen=$(tput setaf 2) 	
_FgYellow=$(tput setaf 3) 	
_FgBlue=$(tput setaf 4) 	
_FgMagenta=$(tput setaf 5) 	
_FgCyan=$(tput setaf 6) 	
_FgWhite=$(tput setaf 7) 	


_FgLightBlack=$(tput setaf 8)
_FgLightRed=$(tput setaf 9)
_FgLightGreen=$(tput setaf 10)
_FgLightYellow=$(tput setaf 11)
_FgLightBlue=$(tput setaf 12)
_FgLightMagenta=$(tput setaf 13)
_FgLightCyan=$(tput setaf 14)
_FgLightWhite=$(tput setaf 15)


# for i in "$(ip link show | grep '.: .*: ')"; do

#     number=$(echo ${i} | cut -d ':' -f1)
#     echo "$i    "
#     echo "${number} "
#     echo ""
# done

for i in $(ip link show | grep ': ' | awk -F': ' '{print $2}'); do 

    echo "${_FgLightBlack}"; 
    # ip link show dev $i
    # echo ""
    # address=$(ip address show dev ${i} | grep 'inet ' | awk -F' ' '{print $2}')
    # echo ${address}

    ifdata=$(ip -j addr show dev ${i})

    ifindex=$(echo $ifdata | jq -r '.[].ifindex')
    ifname=$(echo $ifdata | jq -r '.[].ifname')
    link_type=$(echo $ifdata | jq -r '.[].link_type')
    operstate=$(echo $ifdata | jq -r '.[].operstate')
    address=$(echo $ifdata | jq -r '.[].address')
    broadcast=$(echo $ifdata | jq -r '.[].broadcast')

    echo "${_FgDarkGray} ${ifindex}: ${_FgLightWhite}${ifname} ${_FgDarkGray}${link_type}"

    echo $ifdata | jq '.[].addr_info[].family'
    echo $ifdata | jq '.[].addr_info[].local'
    echo $ifdata | jq '.[].addr_info[].prefixlen'

    echo ""
done