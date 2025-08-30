FROM alpine:3.21

RUN apk update && apk add \
	nginx \
	openssl

RUN mkdir -p /etc/nginx/ssl

# -nodes: no passw for private key
RUN openssl req -x509 \
	-newkey rsa:4096 \
	-keyout /etc/nginx/ssl/certificate.key \
	-out /etc/nginx/ssl/certificate.crt \
	-sha256 \
	-days 3650 \
	-nodes \
	-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=FunnyCompany/OU=DeptOfSilly/CN=$WP_URL"

ARG WEB_USER
ARG WEB_GROUP
COPY conf /etc/nginx/nginx.conf
RUN echo "user $WEB_USER $WEB_GROUP;" >> /etc/nginx/nginx.conf

# -D: no password
# -H: no home
# -s /sbin/nologin: you cannot login as this user
RUN addgroup -S $WEB_GROUP
RUN adduser -D -H -s /sbin/nologin -G $WEB_GROUP $WEB_USER

CMD ["nginx", "-g", "daemon off;"]

# more like documentation, compose file actually exposes the port
EXPOSE 443
