#!/usr/bin/env bash


echo "" > debug.log
mate-terminal --geometry=160x80+1930+0 --zoom=0.5 --working-directory=$(pwd) --title='plug-terminal' --command='tail -f debug.log' &

echo "starting"

# echo 'HiddenServiceDir '$(pwd)'/hidden_service/
# HiddenServicePort 80 127.0.0.1:80
# HiddenServicePort 22 127.0.0.1:22' >> torrc

mkdir -vp $(pwd)/hidden_service
chown -R root.root hidden_service
# chown -R debian-tor.debian-tor hidden_service
chmod -R 700 hidden_service

tor --Log "debug file debug.log" --torrc-file torrc