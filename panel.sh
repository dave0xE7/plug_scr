source lib/terminal.sh

panel_height=3
panel_on=0

function panel_draw() {
    local str width height length

    width=$(tput cols)
    height=$(tput lines)

    # saving the cursor position
    tput sc
    tput civis

    # tput cup 0 0
    tput home
    tput setaf 0
    tput setab 7

    tput home
    tput el
    tput cud1
    tput el
    tput cud1
    tput el

    tput home
    echo "tput character test"
    echo "==================="
    echo "$(date +%s)"

    # restoring the cursor position
    tput cnorm
    tput rc

    #echo "$1" # arguments are accessible through $1, $2,...
}

function panel_update() {
    if (($(Term_row) <= $panel_height)); then
        echo "lesser or equal"
        tput cup $panel_height 0
    fi
    panel_draw
}

function panel_init() {
    tput clear
    tput cup $panel_height 0
    trap 'echo resized' WINCH
    panel_update
}

function panel_run() {
    echo "$1" # arguments are accessible through $1, $2,...
    while true; do
        panel_update
        sleep 1
    done
}

panel_init

# panel_run &
# disown

# panel_run >/dev/null 2>&1

# wait

# Usage: options=("one" "two" "three"); inputChoice "Choose:" 1 "${options[@]}"; choice=$?; echo "${options[$choice]}"
function inputPanel() {
    # echo "${1}"
    shift
    # echo "$(tput dim)""- Change option: [up/down], Select: [ENTER]" "$(tput sgr0)"
    local selected="${1}"
    shift

    ESC=$(echo -e "\033")
    cursor_blink_on() { tput cnorm; }
    cursor_blink_off() { tput civis; }
    cursor_to() { tput cup $(($1 - 1)) $2; }
    print_option() { echo "$(tput sgr0)" "$1" "$(tput sgr0)"; }
    print_selected() { echo -n "$(tput rev)" "$1" "$(tput sgr0)"; }
    get_cursor_row() {
        IFS=';' read -rsdR -p $'\E[6n' ROW COL
        echo "${ROW#*[}"
    }
    key_input() {
        read -rs -n3 key 2>/dev/null >&2
        [[ $key = ${ESC}[A ]] && echo up
        [[ $key = ${ESC}[B ]] && echo down
        [[ $key = ${ESC}[C ]] && echo right
        [[ $key = ${ESC}[D ]] && echo left
        [[ $key = "" ]] && echo enter
    }

    for opt; do echo; done

    local lastrow
    lastrow=$(get_cursor_row)
    local startrow=$((lastrow - $#))
    trap "cursor_blink_on; echo; echo; exit" 2
    cursor_blink_off

    : selected:=0

    while true; do
        local idx=0
        local offset=0
        for opt; do
            length=${#opt}

            #cursor_to $((startrow + idx))
            cursor_to $((startrow)) $offset

            if [ ${idx} -eq "${selected}" ]; then
                print_selected "${opt}"
            else
                print_option "${opt}"
            fi

            ((offset += length + 2))
            ((idx++))
        done

        case $(key_input) in
        enter) break ;;
        left)
            ((selected--))
            [ "${selected}" -lt 0 ] && selected=$(($# - 1))
            ;;
        right)
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

# Usage: options=("one" "two" "three"); inputChoice "Choose:" 1 "${options[@]}"; choice=$?; echo "${options[$choice]}"
panel_options=("one" "two" "three" "asd" "sdfa")
inputPanel "Choose:" 0 "${panel_options[@]}"
choice=$?
echo "${panel_options[$choice]}" selected

function panel_test() {
    echo "$1" # arguments are accessible through $1, $2,...

    # tput setaf 0
    # tput setab 7
    tput clear
    # Usage: options=("one" "two" "three"); inputChoice "Choose:" 1 "${options[@]}"; choice=$?; echo "${options[$choice]}"
    test_options=("one" "two" "three")
    inputChoice "Choose:" 0 "${test_options[@]}"
    choice=$?
    echo "${test_options[$choice]}" selected

}
