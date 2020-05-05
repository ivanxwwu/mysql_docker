#!/bin/sh
/bin/sh /entrypoint.sh mysqld 2>&1 &
/usr/bin/tail -f /dev/null
