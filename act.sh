
prompt() {
	read -p '^' cmd

}

while [ TRUE; ] do
	clear
	echo $PWD
	prompt
done
