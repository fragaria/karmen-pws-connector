#!/bin/bash
#
# Installs Karmen <-> PWS printer connector
#
# This connector is responsible for maintaining upgrades and bug fixes which
# are not possible to perform using Moonraker update manager facilities.

if [ `id -u` != "0" ]; then
    echo "Must be run as root. Trying sudo ..."
    exec sudo $0
fi

export USER=pi
export GROUP=pi
export PI_HOME=/home/$USER
export WORKDIR=$PI_HOME/karmen-pws-connector

echo "Checking existing version ..."
cd $PI_HOME
if [ -d $WORKDIR ]; then
    echo "Service exists, replacing."
    rm -rf $WORKDIR
fi

echo "Installing connector files..."
sudo sudo -u $USER git clone --depth=1 https://github.com/fragaria/karmen-pws-connector.git

cd karmen-pws-connector

echo "Updating system service ..."
# remove existing system service if exists
systemctl stop karmen-pws-connector > /dev/null || echo "Service not running."
systemctl disable karmen-pws-connector > /dev/null || echo "Service does not exist yet."
rm /etc/systemd/system/karmen-pws-connector.service > /dev/null || echo "Service file does not exist yet."
ln -s $WORKDIR/karmen-pws-connector.service /etc/systemd/system
systemctl daemon-reload
systemctl enable karmen-pws-connector
systemctl start karmen-pws-connector

exec ./update.sh
