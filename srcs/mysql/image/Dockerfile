FROM alpine:latest
MAINTAINER lacruype@student.42.fr

ADD repositories etc/apk

RUN apk update \
	&& apk add --no-cache	mariadb \
	 						mariadb-client \
							telegraf

COPY ./nohup-mysql.sh /root/
COPY ./run-mysql /root/
COPY ./init_db.sql /
COPY ./add_db_content.sql /
COPY ./my.cnf /etc/

RUN mkdir -p /etc/telegraf/
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

RUN chmod 777 /add_db_content.sql

EXPOSE 3306
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
CMD sh /root/run-mysql
