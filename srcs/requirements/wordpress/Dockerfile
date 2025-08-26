FROM alpine:3.21
RUN apk update && apk add \
	php83-fpm

	# php83 \
	# fcgi \
	# php82-cgi \
	# wget \
	# mysql-client \
	# php82-mysqli

RUN mkdir -p /usr/share/webapps && \
	cd /usr/share/webapps/ && \
	wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && \
	rm latest.tar.gz

RUN mkdir -p /var/www/localhost/htdocs/wordpress && \
	ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

CMD ["php-fpm83", "-F"]
