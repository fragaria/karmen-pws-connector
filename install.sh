#!/bin/bash

if [ `id -u` != 0]; then
    echo "Must be run as root. Exitting."
    exit 1
fi

cd `dirname $0`
ln -s `pws`/karmen-pws-connector.service /etc/systemd/system
systemctl daemon-update
systemctl enable karmen-pws-connector
systemctl start karmen-pws-connector
