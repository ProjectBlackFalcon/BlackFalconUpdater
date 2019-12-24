#!/bin/bash

VERSION=`curl https://ankama.akamaized.net/zaap/cytrus/cytrus.json | jq '.games.dofus.platforms.linux.main' | tr -d "\""`

MINOR="$(cut -d'.' -f3 <<< $VERSION )"
RELEASE="$(cut -d'.' -f4 <<< $VERSION )"
REVISION="$(cut -d'.' -f5 <<< $VERSION )"

CURRENT_VERSION=`sh /path/to/get_version.sh`

CURRENT_MINOR=`echo $CURRENT_VERSION | jq '.minor' | tr -d "\""`
CURRENT_RELEASE=`echo $CURRENT_VERSION | jq '.release' | tr -d "\""`
CURRENT_REVISION=`echo $CURRENT_VERSION | jq '.revision' | tr -d "\""`

if [ $CURRENT_MINOR -eq $MINOR ] && [ $CURRENT_RELEASE -eq $RELEASE ] && [ $CURRENT_REVISION -eq $REVISION ]
then
	echo "Game up to date"
else
	echo "Update available"
fi
