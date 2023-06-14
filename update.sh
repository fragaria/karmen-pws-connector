#!/bin/bash

set -e
set -x

export USER=pi
export GROUP=pi
export PI_HOME=/home/$USER
export PRINTER_DATA=$PI_HOME/printer_data
export WORKDIR=$PI_HOME/karmen-pws-connector

cd $WORKDIR

VERSION_FILE=/etc/karmen-pws-connector.version

VERSION=`cat $VERSION_FILE` || VERSION=0

_set_version() {
        echo $1 > $VERSION_FILE
}

case $VERSION in
    0)  # initial upgrade (versioning installation)
        cd $WORKDIR
        bash updates/20230607a-installation.sh
        _set_version 1
        VERSION=1
        ;;&
    1)
        # karmen <-> spectoda support
        cd $WORKDIR
        bash updates/20230607b-spectoda.sh
        _set_version 2
        VERSION=2
        ;;&
    1)
        # karmen <-> spectoda support
        cd $WORKDIR
        bash updates/20230614-websocket-restart-interval.sh
        _set_version 3
        VERSION=3
        ;;&
esac

