FROM alpine:latest

ADD repositories etc/apk

RUN  apk update
RUN  apk add --no-cache	php7            \
  						php7-fpm        \
  						php7-opcache    \
  						php7-gd         \
  						php7-mysqli     \
  						php7-zlib       \
  						php7-curl       \
  						php7-mbstring   \
  						php7-json       \
  						php7-session	\
  						telegraf        \
						nginx \
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
			openssl \
			openrc \
&&  wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz \
&&  tar xvf phpMyAdmin-latest-english.tar.gz \
&&  mkdir /www
RUN openrc boot
RUN mkdir -p /var/run/nginx
RUN adduser -D -g 'www' www
RUN chown -R www:www /var/lib/nginx; chown -R www:www /www
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4046 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=lacruype/CN=ft_services"
COPY ./nginx.conf /etc/nginx/

RUN	mv phpMyAdmin-5.* /www/phpmyadmin
RUN	rm phpMyAdmin-latest-english.tar.gz

COPY ./config.inc.php /www/phpmyadmin/
COPY ./run-phpmyadmin /root/run-phpmyadmin
RUN  chmod -R 755 /www/phpmyadmin

RUN mkdir -p /etc/telegraf
COPY telegraf.conf /etc/telegraf/

EXPOSE 5000
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
CMD  sh /root/run-phpmyadmin
