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

    inputMultiChoice() {
        echo "${1}"
        shift
        echo $(tput dim)-"Change Option: [up/down], Change Selection: [space], Done: [ENTER]" $(tput sgr0)
        ESC=$(printf "\033")
        function cursor_blink_on() {
            printf "$ESC[?25h"
        }
        function cursor_blink_off() {
            printf "$ESC[?25l"
        }
        function cursor_to() {
            printf "$ESC[$1;${2:-1}H"
        }
        function print_inactive() {
            printf "$2   $1 "
        }
        function print_active() {
            printf "$2  $ESC[7m $1 $ESC[27m"
        }
        function get_cursor_row() {
            IFS=';' read -sdR -p '[6n' ROW COL
            echo ${ROW#*[}
        }
        function key_input() {
            local key
            IFS= read -rsn1 key 2>/dev/null 1>&2
            if [[ $key = "" ]]; then
                echo enter
            fi
            if [[ $key = ' ' ]]; then
                echo space
            fi
            if [[ $key = '' ]]; then
                read -rsn2 key
                if [[ $key = [A ]]; then
                    echo up
                fi
                if [[ $key = [B ]]; then
                    echo down
                fi
            fi
        }
        function toggle_option() {
            local arr_name=$1
            eval "local arr=(\"\${${arr_name}[@]}\")"
            local option=$2
            if [[ ${arr[option]} == 1 ]]; then
                arr[option]=0
            else
                arr[option]=1
            fi
            eval $arr_name='("${arr[@]}")'
        }
        local retval=$1
        local options
        local defaults
        IFS=';' read -r -a options <<<"$2"
        if [[ -z $3 ]]; then
            defaults=()
            echo "defaults null"
            for ((i = 0; i < ${#options[@]}; i++)); do
                defaults+=("0")
            done
        else
            IFS=';' read -r -a defaults <<<"$3"
        fi
        local selected=()
        for ((i = 0; i < ${#options[@]}; i++)); do
            selected+=("${defaults[i]}")
            printf "\n"
        done
        local lastrow=$(get_cursor_row)
        local startrow=$(($lastrow - ${#options[@]}))
        trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
        cursor_blink_off
        local active=0
        while true; do
            local idx=0
            for option in "${options[@]}"; do
                local prefix="[ ]"
                if [[ ${selected[idx]} == 1 ]]; then
                    prefix="[x]"
                fi
                cursor_to $(($startrow + $idx))
                if [ $idx -eq $active ]; then
                    print_active "$option" "$prefix"
                else
                    print_inactive "$option" "$prefix"
                fi
                ((idx++))
            done
            case $(key_input) in
            space)
                toggle_option selected $active
                ;;
            enter)
                break
                ;;
            up)
                ((active--))
                if [ $active -lt 0 ]; then
                    active=$((${#options[@]} - 1))
                fi
                ;;
            down)
                ((active++))
                if [ $active -ge ${#options[@]} ]; then
                    active=0
                fi
                ;;
            esac
        done
        cursor_to $lastrow
        printf "\n"
        cursor_blink_on
        indices=()
        echo "${selected[@]}"
        for ((i = 0; i < ${#selected[@]}; i++)); do
            if (("${selected[i]}" == "1")); then
                indices+=(${i})
            fi
        done
        eval $retval='("${indices[@]}")'
    }
    inputChoice() {
        echo "${1}"
        shift
        echo $(tput dim)-"Change option: [up/down], Select: [ENTER]" $(tput sgr0)
        local selected="${1}"
        shift
        ESC=$(echo -e "\033")
        function cursor_blink_on() {
            tput cnorm
        }
        function cursor_blink_off() {
            tput civis
        }
        function cursor_to() {
            tput cup $(($1 - 1))
        }
        function print_option() {
            echo $(tput sgr0) "$1" $(tput sgr0)
        }
        function print_selected() {
            echo $(tput rev) "$1" $(tput sgr0)
        }
        function get_cursor_row() {
            IFS=';' read -sdR -p '[6n' ROW COL
            echo ${ROW#*[}
        }
        function key_input() {
            read -s -n3 key 2>/dev/null 1>&2
            [[ $key = $ESC[A ]] && echo up
            [[ $key = $ESC[B ]] && echo down
            [[ $key = "" ]] && echo enter
        }
        for opt in "$@"; do
            echo
        done
        local lastrow=$(get_cursor_row)
        local startrow=$(($lastrow - $#))
        trap "cursor_blink_on; echo; echo; exit" 2
        cursor_blink_off
        : selected:=0
        while true; do
            local idx=0
            for opt in "$@"; do
                cursor_to $(($startrow + $idx))
                if [ ${idx} -eq ${selected} ]; then
                    print_selected "${opt}"
                else
                    print_option "${opt}"
                fi
                ((idx++))
            done
            case $(key_input) in
            enter)
                break
                ;;
            up)
                ((selected--))
                [ "${selected}" -lt 0 ] && selected=$(($# - 1))
                ;;
            down)
                ((selected++))
                [ "${selected}" -ge $# ] && selected=0
                ;;
            esac
        done
        cursor_to "${lastrow}"
        cursor_blink_on
        echo
        return "${selected}"
    }
}
PLUG_LIBRARY_Term