#!/bin/bash

STATUS=`curl -s -o /dev/null -w "%{http_code}" http://localhost:8315/`

if [ $STATUS -eq 200 ]
then
	echo 'Launcher already started'
	exit 0
fi

# Kill all dofus and Xvfb instances
kill `pgrep -f Dofus` && kill `pgrep -f Xvfb`

# Waiting to be sure that Xvbf has been terminated
sleep 5

# Init Xvfb
Xvfb :1 &
export DISPLAY=:1

# Start launcher with devtools
sudo -u user nohup ./DofusLauncherImage.AppImage --remote-debugging-port=8315 > launcher.debug &
