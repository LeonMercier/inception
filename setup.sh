#!/bin/sh

# if no such directory
if [! -d "/var/lib/mariadb/mariadb" ]; then

fi

mariadb-install-db

mariadbd
