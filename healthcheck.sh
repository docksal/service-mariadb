#!/usr/bin/env bash

mysqladmin ping -u root --password=$MYSQL_ROOT_PASSWORD | grep -i 'mysqld is alive' || exit 1

exit 0
