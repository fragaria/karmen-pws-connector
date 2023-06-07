#!/bin/bash
#
# Installs Karmen <-> PWS printer connector
#
# This connector is responsible for maintaining upgrades and bug fixes which
# are not possible to perform using Moonraker update manager facilities.

if [ `id -u` != 0]; then
    echo "Must be run as root. Trying sudo ..."
    exec sudo $0
fi

cd `dirname $0`
rm /etc/systemd/system/karmen-pws-connector.service || true
ln -s `pwd`/karmen-pws-connector.service /etc/systemd/system
systemctl daemon-reload
systemctl enable karmen-pws-connector
systemctl start karmen-pws-connector

if ! grep /home/pi/printer_data/moonraker.asvc > /dev/null; then
    echo 'karmen-pws-connector' >> /home/pi/printer_data/moonraker.asvc
fi
