#!/usr/bin/env bash

appScripDir="$HOME/Library/Application Scripts/com.omnigroup.OmniFocus3/"

# create API key config file for apple scripts
if [ ! -f "config.txt" ]; then
	read -p "API User ID: " apiuserid
	echo "$apiuserid" > config.txt

	read -p "API Token : " apitoken
	echo "$apitoken" >> config.txt
	echo "Created config.txt at $(pwd) containing Habitica API information"
else
	echo "found config.txt already, not overwriting"
fi


# create hard link to folder Omnifocus expects scripts
if [ -f "Task to Habitica.applescript" ]; then
	task2habiticapath=$(realpath ./Task\ to\ Habitica.applescript)
else
	echo "Can't find Task to Habitica.applescript, please verify paths"
	exit 1
fi

if [ ! -f "$appScripDir/Task to Habitica.applescript" ]; then
	ln "$task2habiticapath" "$appScripDir"
else
	echo "found Task to Habitica already in scripts folder, not overwriting"
fi
