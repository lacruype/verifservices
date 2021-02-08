sed -i.bak 's/INFLUX_IP/'"$INFLUXDB_SERVICE_PORT_8086_TCP_ADDR"'/' /etc/telegraf/telegraf.conf
sed -i.bak 's/MY_MYSQL_IP/'$MYSQL_IP'/' /www/wordpress/wp-config.php
rc-service php-fpm7 start
rc-service nginx start
telegraf
