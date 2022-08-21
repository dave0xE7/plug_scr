


get_ipv4_addresses() {
    ip addr | grep -E 'inet ' | grep -v -i '127.0.0.1' | grep -v -i '::1' | awk '{print $2}'
}

for i in $(get_ipv4_addresses); do

    nmap $i -oG /tmp/ipscan --append-output    

done


get_ipv4_addresses

cat /tmp/ipscan | grep 'Status: Up' -A 1 | grep 'Ports'

IPS_UP=$(nmap -nsP 192.168.0.0/24 2>/dev/null -oG - | grep "Up$" | awk '{printf "%s ", $2}')