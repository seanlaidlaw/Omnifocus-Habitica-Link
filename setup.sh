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
if [ -f "scripts/HabiticaWrapper.applescript" ]; then
	task2habiticapath=$(realpath scripts/Task\ to\ Habitica.applescript)
	gsed -i "s+TemplateFilePath+$task2habiticapath+g" scripts/HabiticaWrapper.applescript
else
	echo "Can't find HabiticaWrapper.applescript, please verify paths"
	exit 1
fi
if [ -f "scripts/AutosortWrapper.applescript" ]; then
	autosortpath=$(realpath Autosort.applescript)
	gsed -i "s+TemplateFilePath+$autosortpath+g" scripts/AutosortWrapper.applescript
else
	echo "Can't find AutosortWrapper.applescript, please verify paths"
	exit 1
fi

if [ ! -f "$appScripDir/HabiticaWrapper.applescript" ]; then
	ln "scripts/HabiticaWrapper.applescript" "$appScripDir"
else
	echo "found HabiticaWrapper already in scripts folder, not overwriting"
fi

if [ ! -f "$appScripDir/AutosortWrapper.applescript" ]; then
	ln "scripts/AutosortWrapper.applescript" "$appScripDir"
else
	echo "found AutosortWrapper already in scripts folder, not overwriting"
fi
