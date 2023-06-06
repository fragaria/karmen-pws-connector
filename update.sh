#!/bin/bash

set -e
set -x

VERSION_FILE=/etc/karmen-pws-connector

VERSION=`cat $VERSION_FILE` || VERSION=0

_set_version() {
        echo $1 > $VERSION_FILE
        
}

case $VERSION in
    "")  # initial upgrade (versioning installation)
        _set_version 1
        rm -rf /tmp/0
        VERSION=1
    1)
        mkdir /tmp/2
        _set_version 2
        VERSION=2
        ;;
esac

