#!/bin/sh

cd /usr/share/webapps/wordpress

# www-data does not have a login shell for security reasons, therefore we cannot 
# use 'su'. We could use 'sudo' but it is not installed and configured by 
# default in Alpine. Hence, --allow-root. 

# file created by wp config create
if [ ! -f wp-config.php ]; then
	echo "configuring wordpress"

	#TODO: check that mariadb is up?

	wp core download --allow-root --version=6.8.2

	wp config create \
		--allow-root \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_USER_PW \
		--dbhost=mariadb:3306


fi

echo "DONEEEEEEE"
exec php-fpm83 -F
