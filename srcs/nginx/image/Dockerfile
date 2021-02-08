FROM alpine:latest
MAINTAINER lacruype@student.42.fr

# install packages
RUN apk update	&& apk add nginx \
				&& apk add vim \
				&& apk add openssl \
				&& apk add openssh \
				&& apk add curl \
				&& apk add bash \
				&& apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community telegraf
RUN apk add openssh openrc

RUN openrc boot

#Add user for nginx
RUN mkdir -p var/run/nginx
RUN adduser -D -g 'www' www
RUN mkdir /www ; chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

# Add user for ssh
RUN adduser -D "admin"
RUN echo "admin:admin" | chpasswd
# Config SSH
RUN mkdir -p /home/admin/
COPY ./welcome /home/admin/welcome
RUN mkdir -p test/a/b/c

# Install SSL
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4046 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/www.pem -keyout /etc/nginx/ssl/www.key -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=lacruype/CN=ft_services"
RUN ssh-keygen -A

# Config Telegraf
RUN mkdir -p /etc/telegraf/
COPY telegraf.conf /etc/telegraf/telegraf.conf
CMD sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /etc/telegraf/telegraf.conf

# Config nginx
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./index.html /www/index.html

EXPOSE 80
EXPOSE 443
EXPOSE 22

COPY ./start.sh /start.sh
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
ENTRYPOINT sh /start.sh
