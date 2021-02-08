FROM alpine:latest
MAINTAINER lacruype@student.42.fr

RUN apk update
RUN apk add bash
RUN apk add influxdb
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community telegraf

RUN mkdir -p /etc/telegraf/
COPY telegraf.conf /etc/telegraf/

RUN mkdir -p /etc/influxdb/
COPY ./influxdb.conf /etc/influxdb/

COPY ./start.sh /

EXPOSE 8086
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
ENTRYPOINT sh /start.sh
