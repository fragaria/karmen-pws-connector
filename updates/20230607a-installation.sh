#!/bin/bash
#
# Installs update service on PWS printer

. $WORKDIR/updates/_common

echo "Adding service to Moonraker update manager ..."
if ! grep karmen-pws-connector $PRINTER_DATA/config/moonraker.conf > /dev/null; then
sudo -u pi cat >>$PRINTER_DATA/config/moonraker.conf <<EOD

[update_manager karmen-pws-connector]
type: git_repo
path: ~/karmen-pws-connector
origin: https://github.com/fragaria/karmen-pws-connector.git
primary_branch: main
EOD
fi

if ! grep karmen-pws-connector $PRINTER_DATA/moonraker.asvc > /dev/null; then
    echo 'karmen-pws-connector' >> $PRINTER_DATA/moonraker.asvc
fi

echo "Restarting Moonraker.."
systemctl restart moonraker

echo "Done"
