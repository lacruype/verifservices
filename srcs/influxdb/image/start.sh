#!/bin/sh
sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /etc/telegraf/telegraf.conf
echo $INFLUXDB_SERVICE_PORT_8086_TCP_ADDR >> /a.txt
influxd run > /dev/null &
sleep 10
influx -execute 'CREATE DATABASE influx_db'
influx -execute "CREATE USER influx_user WITH PASSWORD 'influx_password' WITH ALL PRIVILEGES"
influx -execute 'GRANT ALL ON influx_db TO influx_user'
telegraf
