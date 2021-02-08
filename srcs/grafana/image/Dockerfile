FROM alpine:latest
MAINTAINER lacruype@student.42.fr

RUN apk update
RUN apk add bash
RUN  apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community telegraf
RUN apk add sqlite

# Config telegraf
RUN mkdir -p /etc/telegraf/
COPY ./telegraf.conf /etc/telegraf/telegraf.conf

RUN wget https://dl.grafana.com/oss/release/grafana-7.2.0.linux-amd64.tar.gz
RUN tar -zxvf grafana-7.2.0.linux-amd64.tar.gz

RUN mkdir /grafana-7.2.0/data
COPY default.yaml /grafana-7.2.0/conf/provisioning/datasources/
COPY dashboard.yaml /grafana-7.2.0/conf/provisioning/dashboards/
ADD dashboards /grafana-7.2.0/conf/provisioning/dashboards/

COPY start.sh /

#ADD ./dashboards /grafana-7.2.0/conf/provisioning/dashboards

EXPOSE 3000
COPY ./livenessProbe.sh /livenessProbe.sh
RUN chmod 777 livenessProbe.sh
ENTRYPOINT sh start.sh
