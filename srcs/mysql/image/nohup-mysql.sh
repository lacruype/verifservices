#!/bin/sh

until mysql
do
	date=$(date)
	echo $date >> /mysql_nohup.log
done

mysql -u root < /init_db.sql >> /mysql_nohup.log
mysql db_wordpress -u root < /add_db_content.sql >> /mysql_nohup.log
