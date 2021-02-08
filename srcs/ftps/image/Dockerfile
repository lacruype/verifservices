FROM alpine:latest
MAINTAINER lacruype@student.42.fr

RUN apk update
RUN apk add vsftpd openrc openssl vim lftp
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community telegraf

ADD ./vsftpd.conf /etc/vsftpd/
COPY ./start.sh /start.sh

# Config telegraf
RUN mkdir -p /etc/telegraf/
COPY telegraf.conf /etc/telegraf/telegraf.conf

RUN openssl req -newkey rsa:4046 -x509 -sha256 -days 365 -nodes -out /etc/vsftpd/ftp.pem -keyout /etc/vsftpd/ftp.key -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=lacruype/CN=ft_services"

RUN mkdir -p /home/lacruype/
RUN echo "Bienvenue sur mon server" >> /home/lacruype/welcome
RUN adduser -D "lacruype"
RUN echo "lacruype:lacruype" | chpasswd

EXPOSE 21 20
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
CMD sh /start.sh
