FROM alpine:3.21
RUN apk update && apk add mariadb
COPY config /etc/my.cnf.d/mariadb-server.cnf

# adduser seems to create homedir with correct permissions without any chown
RUN mkdir -p /tmp/mariadb && \
	addgroup -S mariadbuser && \
	adduser -S mariadbuser -G mariadbuser -h /var/lib/mariadb && \
	chown -R mariadbuser:mariadbuser /tmp/mariadb && \
	mkdir -p /run/mariadb && \
	chown -R mariadbuser:mariadbuser /run/mariadb && \
	mariadb-install-db
CMD ["mariadbd"]
