# BlackFalconUpdater

> The purpose of the BlackFalconUpdater is to be able to update the game's file (required for the bot to run) automaticaly and without any server X.

This is a proof-of-concept. It works and the scripts provide a somewhat of automation, but it is not production ready (not a all).

## Scripts

- check_update.sh : Compare the current version of the game with the latest version
- DofusLauncherImage.AppImage : Dofus Launcher
- get_version.sh : Get the current version of the game
- restart_launcher.sh : Kill the launcher, restart the fake X server and restart the launcher
- update_with_launcher.sh : Click on the 'Update' button in the launcher
- update.sh : Main script, update the game's file and update the BlackFalcon tools with the new files.

## Usage

To be able to run the launcher on a CLI-only server, you will have to create a fake X server with Xvfb.
The launcher will then be launcher with the argument : `--remote-debugging-port=8315`. It is using the chrome devtools available in an electron app to enable the remote debugging.
You will then be able to access the launcher from http://localhost:8315.
If you have a remote server and wish to access it from http://ip:8315, you can use a tunnel : https://www.cri.ensmp.fr/~coelho/tunnel.c : `./tunnel -Lr ip.of.the.server port localhost 8315`

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
