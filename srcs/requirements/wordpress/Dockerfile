FROM alpine:3.21
# phar, curl, mysqli needed by wp-cli


RUN apk update && apk add \
	php83 \
	php83-fpm \
	php83-phar \
	php83-curl \
	php83-mysqli \
	php83-iconv \
	curl

	# fcgi \
	# php82-cgi \
	# wget \
	# mysql-client \
	# php82-mysqli

COPY config 						/etc/php83/php-fpm.d/www.conf
ARG WEB_USER
ARG WEB_GROUP
RUN echo "user = $WEB_USER" >> 		/etc/php83/php-fpm.d/www.conf
RUN echo "group = $WEB_GROUP" >>	/etc/php83/php-fpm.d/www.conf

COPY php_config /etc/php83/conf.d/override.ini

COPY setup.sh /bin/wordpress_setup.sh
RUN chmod +x /bin/wordpress_setup.sh

# It's possbile to install from https://wordpress.org/latest.tar.gz, 
# but easier just to use wp-cli (wp-cli.org)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN mv wp-cli.phar /bin/wp
RUN chmod +x /bin/wp

RUN mkdir -p /usr/share/webapps/wordpress

# adduser seems to create homedir with correct permissions without any chown
# -D -H no password, no home
RUN addgroup -S $WEB_GROUP
RUN adduser -D -H -s /sbin/nologin -G $WEB_USER $WEB_GROUP

# why does this need to be here and in the script? without this we get a 403...
RUN chown -R ${WEB_USER}:${WEB_GROUP} /usr/share/webapps/wordpress

CMD ["wordpress_setup.sh"]

EXPOSE 9000
