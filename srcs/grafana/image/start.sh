sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /etc/telegraf/telegraf.conf
sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /grafana-7.2.0/data/grafana.db
sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /grafana-7.2.0/conf/provisioning/datasources/default.yaml
cd grafana-7.2.0/bin
./grafana-server & telegraf
