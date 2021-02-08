#!/bin/sh

if [ $(ps -ef | grep "vsftpd /etc/vsftpd/vsftpd.conf" | grep -v "grep" | wc -l) -eq 1 ] && [ $(ps -ef | grep "telegraf" | grep -v "grep" | wc -l) -eq 1 ]; then
	echo "Everything is fine !"
else
	echo "Something is stopped..." && exit 1
fi
