


# if [ -f "/path/to/file" ]; then
#     echo "File \"/path/to/file\" exists"
# fi


# ssh-keygen -t rsa -b 4096
# ssh-keygen -t dsa 
# ssh-keygen -t ecdsa -b 521
# ssh-keygen -t ed25519

# /etc/ssh/ssh_host_dsa_key 
# /etc/ssh/ssh_host_ecdsa_key 
# /etc/ssh/ssh_host_ed25519_key 
# /etc/ssh/ssh_host_rsa_key

mkdir -vp files
mkdir -vp files/etc
mkdir -vp files/etc/ssh

# ssh-keygen -A -f files

# echo 'HostKey '$(pwd)'/files/etc/ssh/ssh_host_rsa_key' >> sshd_config
# echo 'HostKey '$(pwd)'/files/etc/ssh/ssh_host_ecdsa_key' >> sshd_config
# echo 'HostKey '$(pwd)'/files/etc/ssh/ssh_host_ed25519_key' >> sshd_config

if [ ! -d "/run/sshd" ]; then
    echo "directory \"/run/sshd\" doesnt exist"
    mkdir -vp /run/sshd
    chmod 700 /run/sshd
fi


/usr/sbin/sshd -f sshd_config -D -e