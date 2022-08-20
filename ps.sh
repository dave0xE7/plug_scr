
ctd=$TMPDIR/ct
mkdir -p $ctd
ctf=$ctd/$$
echo 0 > $ctf

_a() {
	#echo $EUID;
	ct=$(cat $ctf)
	 ct=$[ct+1]
	echo $ct > $ctf
	echo $ct
}

 PS1=$PS1'$(_a)>'
