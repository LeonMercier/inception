#!/bin/sh

# this is where our volume is mounted
chown -R $WEB_USER:$WEB_GROUP /usr/share/webapps/wordpress
cd /usr/share/webapps/wordpress

# www-data does not have a login shell for security reasons, therefore we cannot 
# use 'su'. We could use 'sudo' but it is not installed and configured by 
# default in Alpine. Hence, --allow-root. 

# file created by wp config create
if [ ! -f wp-config.php ]; then
	echo "configuring wordpress"

	# healthcheck for mariadb is in the compose file so we will just assume 
	# here that it is already up
	
	db_user_pw=$(cat /run/secrets/db_user_pw)
	user_pw=$(cat /run/secrets/wp_user_pw)
	admin_pw=$(cat /run/secrets/wp_root_pw)

	wp core download --allow-root --version=6.8.2

	wp config create \
		--allow-root \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$db_user_pw \
		--dbhost=mariadb:3306

	wp core install \
		--allow-root \
		--url=$WP_URL \
		--title=$WP_SITE_TITLE \
		--admin_user=$WP_ADMIN \
		--admin_password=$admin_pw \
		--admin_email=$WP_ADMIN_EMAIL
	
	wp user create \
		$WP_USER \
		$WP_USER_EMAIL \
		--path=/usr/share/webapps/wordpress \
		--user_pass=$user_pw
fi

# this needs to be done here, in addition to dockerfile because the 'wp'
# commands run as root and create the files for the site
chown -R $WEB_USER:$WEB_GROUP /usr/share/webapps/wordpress

exec php-fpm83 -F
