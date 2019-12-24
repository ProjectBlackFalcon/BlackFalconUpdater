#!/bin/bash

function help() {
        echo "This script allows you to update the game's files."
        echo "$0 <force_build : boolean>"
}

set -e

now=`date`
printf "\n"
echo "$now"

PATH_INVOKER=/home/user/.config/Ankama/zaap/dofus/DofusInvoker.swf

# CHECK THE VERSION
VERSION=`curl https://ankama.akamaized.net/zaap/cytrus/cytrus.json | jq '.games.dofus.platforms.linux.main' | tr -d "\""`

MINOR="$(cut -d'.' -f3 <<< $VERSION )"
RELEASE="$(cut -d'.' -f4 <<< $VERSION )"
REVISION="$(cut -d'.' -f5 <<< $VERSION )"

CURRENT_VERSION=`sh /home/user/auto_update/get_version.sh`

CURRENT_MINOR=`echo $CURRENT_VERSION | jq '.minor' | tr -d "\""`
CURRENT_RELEASE=`echo $CURRENT_VERSION | jq '.release' | tr -d "\""`
CURRENT_REVISION=`echo $CURRENT_VERSION | jq '.revision' | tr -d "\""`

if [ $CURRENT_MINOR -eq $MINOR ] && [ $CURRENT_RELEASE -eq $RELEASE ] && [ $CURRENT_REVISION -eq $REVISION ]
then
	echo "Game up to date"
	if [ "$1" = true ] ; then
  		echo 'Forcing build'
	else
		exit 0
	fi
else
	echo "Update $VERSION available"
	# RESTART LAUNCHER
	echo "Restarting Launcher"
	sudo sh /home/user/auto_update/restart_launcher.sh
	sleep 300
	# Kill all dofus and Xvfb instances
	sudo kill `pgrep -f Dofus` && kill `pgrep -f Xvfb`
	# START UPDATE WITH LAUNCHER
	# echo "Updating the game"
	# node /home/user/auto_update/update_with_launcher.js
fi

# CHECK THE VERSION AGAIN
CURRENT_VERSION=`sh /home/user/auto_update/get_version.sh`
CURRENT_MINOR=`echo $CURRENT_VERSION | jq '.minor' | tr -d "\""`
CURRENT_RELEASE=`echo $CURRENT_VERSION | jq '.release' | tr -d "\""`
CURRENT_REVISION=`echo $CURRENT_VERSION | jq '.revision' | tr -d "\""`

if [ $CURRENT_MINOR -eq $MINOR ] && [ $CURRENT_RELEASE -eq $RELEASE ] && [ $CURRENT_REVISION -eq $REVISION ]
then
	echo "Game up to date"
else
	echo "Game not updated correctly, exiting"
	exit 1
fi

cd /home/user
# PROTOCOL BUILDER
cd ProtocolBuilder ; git reset --hard HEAD ; git pull
echo "Building Protocol builder"
mvn clean package
echo "Generating files"
java -jar target/protocol-builder-1.0-jar-with-dependencies.jar -f $PATH_INVOKER -o ../BlackFalconAPI/src/main/java/
cd /home/user

# BLACK FALCON API
echo "Building API"
cd BlackFalconAPI ; git reset --hard HEAD ; git pull
echo "Getting new version"
sh /home/user/auto_update/get_version.sh > /home/user/BlackFalconAPI/src/main/resources/Version.json
mvn clean package
cd /home/user

# ASSETS MANAGER
echo "Managing assets"
sh /home/user/AssetsManager/assets_manager.sh
echo "My work is done, have fun botting
