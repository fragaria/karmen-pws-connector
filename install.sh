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

HOME=/home/pi

echo "Checking existing version ..."
cd $HOME
if [ -d /home/pi/karmen-pws-connector ]; then
    echo "Service exists, replacing."
    rm -rf /home/pi/karmen-pws-connector
fi

echo "Installing connector files..."
git clone --depth=1 https://github.com/fragaria/karmen-pws-connector.git

echo "Updating system service ..."
rm /etc/systemd/system/karmen-pws-connector.service || true
ln -s $HOME/karmen-pws-connector.service /etc/systemd/system
systemctl daemon-reload
systemctl enable karmen-pws-connector
systemctl start karmen-pws-connector

echo "Adding service to Moonraker update manager ..."
if ! grep karmen-pws-connector $HOME/printer_data/config/moonraker.conf > /dev/null; then
sudo -u pi cat >>$HOME/printer_data/config/moonraker.conf <<EOD
[update_manager karmen-pws-connector]
    type: git_repo
    path: ~/karmen-pws-connector
    origin: https://github.com/fragaria/karmen-pws-connector.git
    primary_branch: main
EOD
fi

if ! grep /home/pi/printer_data/moonraker.asvc > /dev/null; then
    echo 'karmen-pws-connector' >> /home/pi/printer_data/moonraker.asvc
fi

echo "All done"
