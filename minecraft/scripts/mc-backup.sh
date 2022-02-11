#!/bin/bash
FILENAME=$(date "+%Y%m%d-%H%M%S")-world.tar.gz 
MINECRAFTSTATUS=`systemctl is-active minecraft`

if [ $MINECRAFTSTATUS == "active" ]
then
	/usr/bin/tmux send-keys -t mcs.0 '/say "Server Backup In Progress"' ENTER
	/usr/bin/tmux send-keys -t mcs.0 '/save-all flush' ENTER
	/usr/bin/tmux send-keys -t mcs.0 '/save-off' ENTER
	sleep 30
	tar -zcvf /opt/minecraft/$FILENAME /opt/minecraft/world
	mv /opt/minecraft/$FILENAME /media/backups/
	/usr/bin/tmux send-keys -t mcs.0 '/save-on' ENTER
	sleep 10
	/usr/bin/tmux send-keys -t mcs.0 '/say "Server Backup Complete"' ENTER
else
	echo "Minecraft Service is not running"
fi
