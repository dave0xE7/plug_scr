#!/bin/bash

#
#
# to be run on termux
#
#   curl -q example.com/install-cool-program.sh | bash

pkg_update() {
  pkg upgrade -y
  pkg update -y
}

pkg_install() {
  if ! pkg install $@ -y; then
    pkg_update
    pkg_install $@
  fi
}

pkg_install wget curl git nodejs

if compgen -c sv; then
	echo "termux-service installed"
else
	pkg install termux-services -y
fi

SVDIR=$PREFIX/usr/var/service/polycon

if [ ! -f $SVDIR/run ]; then
  mkdir -v -p $SVDIR
  echo '#!/data/data/com.termux/files/usr/bin/sh' > $SVDIR/run
  echo 'cd /data/data/com.termux/files/home/polycon' >> $SVDIR/run
  echo 'exec node src/main.sh 2>&1' >> $SVDIR/run
fi

sv status polycon
sv restart polycon
sv-enable polycon
sv status polycon

# Settung up SSHd
echo "Settung up SSHd"

pkg install openssh -y

mkdir -v -p ~/.ssh

if [ ! -f ~/.ssh/id_rsa ]; then
    echo "File \"~/.ssh/id_rsa\" doesnt exist"
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
fi

sv status sshd
sv-enable sshd
sv restart sshd
sv status sshd

echo "done!"

# https://wiki.termux.com/wiki/Bypassing_NAT
# Setting up Onion Service

pkg install tor
pkg install proxychains-ng

# these lines will be addred to $PREFIX/etc/tor/torrc
######################################################
#
# ## Enable TOR SOCKS proxy
# SOCKSPort 127.0.0.1:9050
#
# ## Hidden Service: SSH
# HiddenServiceDir /data/data/com.termux/files/home/.tor/hidden_ssh
# HiddenServicePort 22 127.0.0.1:8022
#
############################################################

if grep 'Hidden Service: SSH' $PREFIX/etc/tor/torrc; then

    echo "Configuration lines for Hidden Service: SSH"
    echo "already exists in /etc/tor/torrc"

else

    echo "No configuration lines for Hidden Service: SSH"
    echo "could be found in /etc/tor/torrc"
    echo ""
    echo "Writing new configuration now"

tee -a $PREFIX/etc/tor/torrc <<END
## Enable TOR SOCKS proxy
SOCKSPort 127.0.0.1:9050

## Hidden Service: SSH
HiddenServiceDir /data/data/com.termux/files/home/.tor/hidden_ssh
HiddenServicePort 22 127.0.0.1:8022
HiddenServicePort 30000 127.0.0.1:30000
END

fi

mkdir -v -p ~/.tor/hidden_ssh

sv status tor
sv-enable tor
sv restart tor
sv status tor


if [ -f ~/.tor/hidden_ssh/hostname ]; then
    echo "File \"~/.tor/hidden_ssh/hostname\" exists"
    cat ~/.tor/hidden_ssh/hostname 
fi


