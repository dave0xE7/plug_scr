


# A list of color codes
# Color 	Code
# Black 	0;30
# Blue 	0;34
# Green 	0;32
# Cyan 	0;36
# Red 	0;31
# Purple 	0;35
# Brown 	0;33
# Blue 	0;34
# Green 	0;32
# Cyan 	0;36
# Red 	0;31
# Purple 	0;35
# Brown 	0;33

echo -e '\e[0;31m asdf \e[masdadf'


    # \e[ : Start color scheme.
    # x;y : Color pair to use (x;y)
    # \e[m : Stop color scheme.



# Various color codes for the tput command
# Color {code} 	Color
# 0 	Black
# 1 	Red
# 2 	Green
# 3 	Yellow
# 4 	Blue
# 5 	Magenta
# 6 	Cyan
# 7 	White

# _GREEN=$(tput setaf 2)
# _BLUE=$(tput setaf 4)
# _RED=$(tput setaf 1)

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

echo "test $(tput setaf 0) color ${_RESET}" 	
echo "test $(tput setaf 1) color ${_RESET}" 	
echo "test $(tput setaf 2) color ${_RESET}" 	
echo "test $(tput setaf 3) color ${_RESET}" 	
echo "test $(tput setaf 4) color ${_RESET}" 	
echo "test $(tput setaf 5) color ${_RESET}" 	
echo "test $(tput setaf 6) color ${_RESET}" 	
echo "test $(tput setaf 7) color ${_RESET}" 


echo "test $(tput setaf 8) collor ${_RESET}" 	
echo "test $(tput setaf 9) collor ${_RESET}" 	
echo "test $(tput setaf 10) collor ${_RESET}" 	
echo "test $(tput setaf 11) collor ${_RESET}" 	
echo "test $(tput setaf 12) collor ${_RESET}" 	
echo "test $(tput setaf 13) collor ${_RESET}" 	
echo "test $(tput setaf 14) collor ${_RESET}" 	
echo "test $(tput setaf 15) collor ${_RESET}" 	


# echo "test ${_BOLD} $(tput setaf 8) collor ${_RESET}" 	
# echo "test $(tput setaf 9) collor ${_RESET}" 	
# echo "test $(tput setaf 10) collor ${_RESET}" 	
# echo "test $(tput setaf 11) collor ${_RESET}" 	
# echo "test $(tput setaf 12) collor ${_RESET}" 	
# echo "test $(tput setaf 13) collor ${_RESET}" 	
# echo "test $(tput setaf 14) collor ${_RESET}" 	
# echo "test $(tput setaf 15) collor ${_RESET}"

