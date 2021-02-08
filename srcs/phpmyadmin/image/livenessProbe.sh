#!/bin/sh

if [ $(ps -ef | grep "nginx: master proces" | grep -v "grep" | wc -l) -eq 1 ] && [ $(ps -ef | grep "nginx: worker process" | grep -v "grep" | wc -l) -eq 1 ] && [ $(ps -ef | grep "/usr/bin/telegraf" | grep -v "grep" | wc -l) -eq 1 ]; then
	echo "Everything is fine !"
else
	echo "Something is stopped..." && exit 1
fi
