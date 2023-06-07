#!/bin/bash
#
# Modifies PWS printer to allow karmen to communicate with spectoda leds

. $WORKDIR/updates/_common


echo "Fixing permissions of configuration files."

for filename in websocket-proxy.conf karmen-key.txt ; do
    chown $USER:$GROUP $PRINTER_DATA/config/$filename
done

echo "Done"


echo "Adding spectoda leds port to allowed ports."

CONFIG_FILE=$PRINTER_DATA/config/websocket-proxy.conf
sudo -u $USER grep -v FORWARD_TO_PORTS $CONFIG_FILE > /tmp/spectoda-pws-upgrade.tmp

sudo -u $USER tee $PRINTER_DATA/config/websocket-proxy.conf > /dev/null <<EOF
`cat /tmp/spectoda-pws-upgrade.tmp`
FORWARD_TO_PORTS=80,8888
EOF


echo "Done"

echo "Restarting system services"
systemctl daemon-reload
systemctl restart websocket-proxy moonraker
echo "Done"
