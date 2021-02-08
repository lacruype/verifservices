FROM alpine:latest
MAINTAINER lacruype@student.42.fr

# install packages
RUN apk add lighttpd \
			php7-common \
			php7-iconv \
			php7-json \
			php7-gd \
			php7-curl \
			php7-xml \
			php7-mysqli \
			php7-imap \
			php7-cgi \
			fcgi \
			php7-pdo \
			php7-pdo_mysql \
			php7-soap \
			php7-xmlrpc \
			php7-posix \
			php7-mcrypt \
			php7-gettext \
			php7-ldap \
			php7-ctype \
			php7-dom \
			php7-fpm \
			vim \
			curl \
			php \
			php7 \
			nginx \
			openssl 
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community telegraf

RUN apk add openrc
RUN openrc boot


RUN mkdir -p /var/run/nginx
RUN adduser -D -g 'www' www
RUN mkdir /www ; chown -R www:www /var/lib/nginx ; chown -R www:www /www

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4046 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=lacruype/CN=ft_services"

COPY ./nginx.conf /etc/nginx/

RUN mkdir -p /etc/telegraf
COPY telegraf.conf /etc/telegraf

ADD lighttpd.conf /etc/lighttpd/
ADD mod_fastcgi.conf /etc/lighttpd/

RUN mkdir -p /www/ \
	&& cd /www/ \
	&& chmod 777 /www/

RUN wget http://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN mv wordpress /www/
COPY wp-config.php /www/wordpress/wp-config.php

COPY ./start.sh ./
COPY ./set_wordpress_ip.sh /set_wordpress_ip.sh
RUN chmod 777 /set_wordpress_ip.sh

EXPOSE 5050
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
ENTRYPOINT sh ./start.sh
