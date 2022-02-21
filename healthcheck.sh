#!/usr/bin/env bash

mysqladmin ping --host=127.0.0.1 --port=3306 --user=root --password=$MYSQL_ROOT_PASSWORD | grep -i 'mysqld is alive' || exit 1

exit 0
