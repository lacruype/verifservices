#!/bin/sh

if [ $(ps -ef | grep "/usr/sbin/sshd" | grep -v "grep" | wc -l) -eq 1 ] && [ $(ps -ef | grep "nginx: master process" | grep -v "grep" | wc -l) -eq 1 ] && [ $(ps -ef | grep "telegraf" | grep -v "grep" | wc -l) -eq 1 ]; then
	echo "Everything is fine !"
else
	echo "Something is stopped..." && exit 1
fi
