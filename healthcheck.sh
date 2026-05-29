#!/usr/bin/env bash

# MariaDB 11.x ships mariadb-admin, while older releases still include mysqladmin.
ADMIN_BIN=$(command -v mysqladmin || command -v mariadb-admin)
"${ADMIN_BIN}" ping --silent --host=127.0.0.1 --port=3306 --user=root --password="$MYSQL_ROOT_PASSWORD" || exit 1

exit 0
