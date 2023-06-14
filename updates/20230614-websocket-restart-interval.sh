#!/bin/bash
#
# Reconfigures Websocket Proxy to restart less frequently to prevent "system failed" state

cd "$(dirname $0)"

. _common

sudo sed -i 's/RestartSec=1/RestartSec=5/g' /etc/systemd/system/websocket-proxy.service
