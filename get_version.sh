#!/bin/bash

TARGET_LOCATION=/path/to/Ankama/zaap/dofus/VERSION
TARGET_CONTENT=$(cat $TARGET_LOCATION)

JSON_STRING=$( jq -n \
                  --arg maj `echo $TARGET_CONTENT | awk -F. '{print $1}'` \
                  --arg min `echo $TARGET_CONTENT | awk -F. '{print $2}'` \
                  --arg rel `echo $TARGET_CONTENT | awk -F. '{print $3}'` \
                  --arg rev `echo $TARGET_CONTENT | awk -F. '{print $4}'` \
		  --arg patch 1 \
                  '{major: $maj, minor: $min, release: $rel, revision: $rev, patch: $patch}' )
echo $JSON_STRING
