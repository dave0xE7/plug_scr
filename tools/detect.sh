#!/bin/bash

# IP=$(ifconfig wlx08bd43882d68 | grep mask | cut -d ':' -f2 | cut -d " " -f1)
IP=$(ifconfig wlx08bd43882d68 | grep 'inet ' | awk -F' ' '{print $2}')
# Mask=$(ifconfig wlx08bd43882d68 | grep mask | cut -d ':' -f4 | cut -d " " -f1)
Mask=$(ifconfig wlx08bd43882d68 | grep 'inet ' | awk -F' ' '{print $4}')
IFS=.
IPArray=($IP)
MaskArray=($Mask)
NetArray=()
Start=0
Max=$(( 255 * 255 * 255 * 255 ))
for key in "${!IPArray[@]}";
do
   NetArray[$key]=$(( ${IPArray[$key]} & ${MaskArray[$key]} ))
   Start=$(( $Start + (${NetArray[$key]} << (3-$key)*8) )) 
done
IFS=
echo "Your IP Address   : $IP"
echo "Your N/W Mask     : $Mask"
echo "Your N/W Address  : ${NetArray[@]}"
echo "IPs to be Checked : $(( $Max - $Start ))"
for ((IPs=$Start; IPs <= $Max; IPs++))
do 
   IP=$(( IPs >> 24 ))
   IP="$IP.$(( (IPs >> 16) & 255 ))"
   IP="$IP.$(( (IPs >> 8) & 255 ))"
   IP="$IP.$(( IPs & 255 ))"
   $(ping -c 1 -w 1 $IP >& /dev/null)
   if [[ $? -eq 0 ]]; then
      echo "$IP exists in Network. Just $(( $Max - $IPs )) more to go."
   fi
done
