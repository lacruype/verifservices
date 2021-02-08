#!/bin/sh

if [ $(ps -ef | grep "sh /root/run-mysql" | grep -v "grep" | wc -l) -eq 1 ] && [ $(ps -ef | grep "/usr/bin/mysqld" | grep -v "grep" | wc -l) -eq 2 ] && [ $(ps -ef | grep "/usr/bin/telegraf" | grep -v "grep" | wc -l) -eq 1 ]; then
	echo "Everything is fine !"
else
	echo "Something is stopped..." && exit 1
fi
