#!/usr/bin/env bash

cmd=''

key_input() {
	local key
	IFS= read -rsn1 key 2>/dev/null >&2
	if [[ $key = ""      ]]; then echo enter; fi;
	if [[ $key = $'\x20' ]]; then echo space; fi;
	if [[ $key = $'\x1b' ]]; then
		read -rsn2 key
		echo -ne "key=$key"
		if [[ $key = [A ]]; then echo up;    fi;
		if [[ $key = [B ]]; then echo down;  fi;
	fi
}

while true; do
	case $(key_input) in
		space) echo "space";;
		# space)  toggle_option selected $active;;
		enter)  break;;
		*) echo "key: $key";;
		# up)     ((active--));
			# if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
		# down)   ((active++));
			# if [ "$active" -ge ${#options[@]} ]; then active=0; fi;;
	esac
done

prompt() {
#	while [ TRUE ]; do
		read -e -i "$cmd" -n 1 -p '^' cmd
		case "${cmd}" in
			".")
				read -n 1 cmd2
				if [[ "${cmd2}" == "." ]]; then
					cd ..
				fi
			;;
			q)
				echo "quitting"
				exit 0
			;;
			*)
				echo ""
				echo "$(tput setaf 1)"
				compgen -o filenames -A file $cmd
				echo "$(tput sgr0)"

				cmd="$"

				# while [ TRUE ]; do
				# 	tput cup 1 0
				# 	read -e -i "$cmd" -p '^' -n 1 cmd2
				# 	if [[ "${cmd2}" == "${cmd}" ]]; then
				# 		echo "The two strings are the same"
				# 		break 1;
				# 	else
				# 		cmd=$cmd2
				# 	fi
					
				# 	compgen -o filenames -A file $cmd
				# 	#echo "default (none of above)"
				# done
			;;
		esac
		
		# if [[ "${cmd}" == "/" ]]; then
		# 	echo "The two strings are the same"
		# fi
#	done
}

# while [ TRUE ]; do
# 	clear
# 	echo $PWD
# 	tput cup 2 0
# 	if (( $(ls -1 | wc -l) >= $(tput lines) )); then
# 		ls -FC --color=always
# 	else	
# 		ls -F1 --color=always
# 	fi
# 	tput cup 1 $(pwd | wc -c)
# 	prompt
# done
