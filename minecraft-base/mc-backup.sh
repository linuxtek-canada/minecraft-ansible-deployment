#!/bin/bash
FILENAME=$(date "+%Y%m%d-%H%M%S")-world.tar.gz 
MINECRAFTSTATUS=`systemctl is-active minecraft`

if [ $MINECRAFTSTATUS == "active" ]
then
	screen -p 0 -S mcs -X stuff '/say "Server Backup In Progress"\n'
	screen -p 0 -S mcs -X stuff '/save-all flush\n'
	screen -p 0 -S mcs -X stuff '/save-off\n'
	sleep 30
	tar -zcvf /opt/minecraft/$FILENAME /opt/minecraft/world
	mv /opt/minecraft/$FILENAME /media/backups/
	screen -p 0 -S mcs -X stuff '/save-on\n'
	sleep 10
	screen -p 0 -S mcs -X stuff '/say "Server Backup Complete"\n'
else
	echo "Minecraft Service is not running"
fi
