#!/bin/sh

# mariadb-install-db creates a folder called 'mysql' in the datadir
# "if directory doesn't exist"
if [ ! -d "/var/lib/mariadb/mysql" ]; then
	mariadb-install-db --basedir=/usr --datadir=/var/lib/mariadb \
		--user=mariadbuser

	# --bootstrap: do not daemonize; read SQL from stdin
	#
	# $DB_USER@'%' => allow user to connect from any host; % is wildcard
	# due to mariadb host matching weirdness (and --bootstrap) we need another
	# set of commands with 'localhost' instead of '%' to to allow connections
	# from localhost, which in turn are needed for our compose healthcheck.
	#
	# $DB_NAME.* => all tables in that database
	#
	# hyphen after << means heredoc will strip leading whitespace => we can 
	# indent our heredoc nicely
	
	user_pw=$(cat /run/secrets/db_user_pw)
	root_pw=$(cat /run/secrets/db_root_pw)
	mariadbd --bootstrap --user=mariadbuser <<- EOF
		USE mysql;
		FLUSH PRIVILEGES;
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_pw';
		CREATE DATABASE $DB_NAME;
		CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$user_pw';
		CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$user_pw';
		GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
		GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
		FLUSH PRIVILEGES;
	EOF
fi


# exec replaces current shell with the command, docker needs the process to
# be PID 1, so that signals are correctly propagated
exec mariadbd-safe
