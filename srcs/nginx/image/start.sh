sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /etc/telegraf/telegraf.conf
sed -i.bak 's/WP_IP/'$WP_IP'/' /etc/nginx/nginx.conf
sed -i.bak 's/PMA_IP/'$PMA_IP'/' /etc/nginx/nginx.conf
rc-service nginx start
/usr/sbin/sshd & telegraf
