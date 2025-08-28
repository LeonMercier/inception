#!/bin/sh

# mariadb-install-db creates a folder called 'mysql' in the datadir
# "if directory doesn't exist"
if [ ! -d "/var/lib/mariadb/mysql" ]; then
	mariadb-install-db --basedir=/usr --datadir=/var/lib/mariadb \
		--user=mariadbuser

	# $DB_USER@'%' => allow user to connect from any host; % is wildcard
	# $DB_NAME.* => all tables in that database
	# hyphen after << means heredoc will strip leading whitespace => we can 
	# indent our heredoc nicely
	mariadbd --user=mariadbuser <<- EOF
		USE mysql;
		ALTER USER 'root'@'localhost' IDENTIFIED BY "$DB_ROOT_PW";
		CREATE DATABASE $DB_NAME;
		CREATE USER $DB_USER@'%' IDENTIFIED BY "$DB_USER_PW";
		GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'%';
	EOF
fi

# exec replaces current shell with the command, docker needs the process to
# be PID 1, so that signals are correctly propagated
exec mariadbd-safe
