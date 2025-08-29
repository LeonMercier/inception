FROM alpine:3.21

# mariadb-client is for mariadb-admin for healthcheck
RUN apk update && apk add mariadb mariadb-client

COPY config /etc/my.cnf.d/mariadb-server.cnf

COPY setup.sh /usr/bin/mariadb_setup.sh
RUN chmod +x /usr/bin/mariadb_setup.sh

# adduser seems to create homedir with correct permissions without any chown
RUN addgroup -S mariadbuser && \
	adduser -S mariadbuser -G mariadbuser -h /var/lib/mariadb

RUN mkdir -p /tmp/mariadb && chown -R mariadbuser:mariadbuser /tmp/mariadb

RUN mkdir -p /run/mariadb && chown -R mariadbuser:mariadbuser /run/mariadb

CMD ["mariadb_setup.sh"]
