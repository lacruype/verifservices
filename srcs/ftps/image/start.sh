sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /etc/telegraf/telegraf.conf
vsftpd /etc/vsftpd/vsftpd.conf &
telegraf
