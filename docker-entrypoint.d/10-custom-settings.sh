#!/usr/bin/env bash

if [[ "$(id -u)" = '0' ]]; then
	# Copy custom settings (if mounted) from /var/www/.docksal/etc/mysql/my.cnf and fix permissions
	project_config_file='/var/www/.docksal/etc/mysql/my.cnf'
	echo "Including custom configuration from ${project_config_file}"
	if [[ -f ${project_config_file} ]]; then
		cp -a ${project_config_file} /etc/mysql/conf.d/99-overrides.cnf
		chown -R root:root /etc/mysql/conf.d/*
		chmod -R 644 /etc/mysql/conf.d/*
	fi
fi
