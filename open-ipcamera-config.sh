#!/bin/bash

source "${BASH_SOURCE%/*}/variables.sh"
source "${BASH_SOURCE%/*}/functions.sh"

# The open-ipcamera Project: www.open-ipcamera.net
# Developer:  Terrence Houlahan Linux Engineer F1Linux.com
# https://www.linkedin.com/in/terrencehoulahan/
# Contact: terrence.houlahan@open-ipcamera.net
# Version 1.40

######  COMPATIBILITY: ######
# "open-ipcamera-config.sh": Installs and configs Raspberry Pi camera application, related camera Kernel module and motion detection alerts
#   Hardware:   Raspberry Pi 2/3B+
#   OS:         Raspbian "Stretch" 9.6 (lsb_release -a)

######  LICENSE: ######
# Copyright (C) 2018 2019 Terrence Houlahan
# License: GPL 3:
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not see <https://www.gnu.org/licenses/>.


######  INSTALL INSTRUCTIONS: ######

# WARNING:  Edit *variables.sh* with your unique data info before executing this script

# README.txt file distributed with this script
# VIDEO:  www.YouTube.com/user/LinuxEngineer
#         The Video contains all steps required to produce an enterprise-grade Motion Detection Camera using this script
#         And most helpfully the video begins with a section index to enable skipping directly to the section you want

######  DEVELOPER BEER-FUND: ######

# Developing Open Source projects is thirsty work.  If you found this project useful and want to buy me a beer:
#   paypal.me/TerrenceHoulahan

#########################################

echo
echo "$(tput setaf 5)****** LICENSE:  ******$(tput sgr 0)"
echo

echo '*open-ipcamera-config.sh* and all related scripts in this repository are Copyright (C) 2018 2019 Terrence Houlahan'
echo
echo "This program comes with ABSOLUTELY NO WARRANTY express or implied."
echo "This is free software and you are welcome to redistribute it under certain conditions."
echo "Consult * LICENSE.txt * for terms of GPL 3 License and conditions of use."

read -p "Press ENTER to accept license and warranty terms to continue or close this bash shell to exit script"


echo
echo "$(tput setaf 5)****** CREDITS:  ******$(tput sgr 0)"
echo
echo "My script is a wrapper that stitches together the work of the below projects into a complete Motion Detection Camera Solution."
echo "Just wanted to take a moment to thank these Open Source folks who toil in anonymity that provided me with the key components for my efforts:"
echo
echo "Dropbox_Uploader Developer Andrea Fabrizi whose scripts are used by my wrapper to shift images from local USB Flash storage to Dropbox"
echo "		$(tput setaf 2) https://github.com/andreafabrizi/Dropbox-Uploader.git $(tput sgr 0)"
echo
echo "Motion Project Developers Joseph Heenan * Mr-Dave *  Tosiara.  Motion is used for motion detection image capture"
echo "		$(tput setaf 2) https://github.com/orgs/Motion-Project/people$(tput sgr 0)"
echo
echo "MSMTP Developer Martin Lambers: SMTP client used to relay alerts"
echo "		$(tput setaf 2) https://gitlab.marlam.de/marlam/msmtp$(tput sgr 0)"
echo
echo "And kudos to DROPBOX for providing their Enterprise-class API used for shifting images from USB storage to cloud"
echo
echo "$(tput setaf 6)     - Terrence Houlahan Linux Engineer and open-ipcamera Project founder ( houlahan@F1Linux.com )$(tput sgr 0)"
echo


# Determine if a FULL INSTALL or UPGRADE is required by testing for presence of the file variables.sh.asc:
if [ ! -f $PATHSCRIPTS/version.txt ]; then
	echo
	echo "No previous install of open-ipcamera found. Performing full install of open-ipcamera"
	echo
else
	echo
	echo "Previous open-ipcamera install found. Perform * UPGRADE * from current version to latest"
	echo
	echo "Download bash shell script $PATHSCRIPTS/upgrade_open-ipcamera.sh from this Pi to your Mac or Linux host and execute it from there"
	exit
fi


echo
echo "$(tput setaf 5)****** PACKAGE MANAGEMENT:  ******$(tput sgr 0)"
echo

./packages.sh&
wait $!


echo
echo "$(tput setaf 5)****** IMAGE STORAGE CONFIGURATION:  ******$(tput sgr 0)"
echo

./storage.sh&
wait $!



echo
echo "$(tput setaf 5)****** CONFIGURE LOGGING:  ******$(tput sgr 0)"
echo

./log-config.sh 2>> $PATHLOGINSTALL/install.log&
wait $!





echo
echo "$(tput setaf 5)******  SET HOSTNAME:  ******$(tput sgr 0)"
echo

./hostname.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)******  systemd-timesyncd.service CONFIGURATION  ******$(tput sgr 0)"
echo

./timedate.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** USER CONFIGURATION: ******$(tput sgr 0)"
echo

./user-pi.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** SET BOOT PARAMS:  ******$(tput sgr 0)"
echo

./boot-params.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo
echo "$(tput setaf 5)****** CAMERA KERNEL DRIVER: Load on Boot  ******$(tput sgr 0)"
echo

./kernel-drivers.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** Create Graph of Dependent Relationships Between Services on Boot:  ******$(tput sgr 0)"
echo

./service-graphServices.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo
echo "$(tput setaf 5)******  /etc/ssh/sshd_config CONFIGURATION  ******$(tput sgr 0)"
echo

./sshd-config.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** SNMP CONFIGURATION:  ******$(tput sgr 0)"
echo

./monitoring-snmp.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** DROPBOX CONFIGURATION  ******$(tput sgr 0)"
echo

./service-dropboxUploader.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** Camera Software *MOTION* Configuration  ******$(tput sgr 0)"
echo
echo 'Further Info: https://motion-project.github.io/motion_config.html'
echo

./service-motion.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** MAIL ALERTS CONFIGURATION: SMTP Relay Configuration  ******$(tput sgr 0)"
echo

./smtpRelay-msmtp.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** MAIL ALERTS CONFIGURATION: IP Address and Heat  ******$(tput sgr 0)"
echo

./service-emailCameraAddress.sh 2>> $PATHLOGINSTALL/install.log&
wait $!


./service-emailMotionDetectionCameraAddress.sh 2>> $PATHLOGINSTALL/install.log&
wait $!


./service-heatAlert.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** TROUBLESHOOTING SCRIPT:  ******$(tput sgr 0)"
echo

./troubleshooting.sh 2>> $PATHLOGINSTALL/install.log&
wait $!




echo
echo "$(tput setaf 5)****** SET CPU AFFINITY:  ******$(tput sgr 0)"
echo

./service-CPUaffinity.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo
echo "$(tput setaf 5)****** Login Messages CONFIGURATION:  ******$(tput sgr 0)"
echo

./login-messages.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo
echo
echo "$(tput setaf 5)****** CONFIRM DROPBOX ACCESS TOKEN:  ******$(tput sgr 0)"
echo

./dropbox-accessToken.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo
echo "$(tput setaf 5)****** Create *version.txt* File Required to Update open-ipcamera: ******$(tput sgr 0)"
echo


### version.txt

# Delete *version.txt* file so it can be replaced with the updated version reflecting this install:
if [ -f $PATHSCRIPTS/version.txt ]; then
	chatter -i $PATHSCRIPTS/version.txt
	rm $PATHSCRIPTS/version.txt
fi

# Create *version.txt* echoing the version number just installed into it:
echo "# *****   THIS FILE HAS PERMS SET TO 'IMMUTABLE'   *****#" >> $PATHSCRIPTS/version.txt
echo "# ** USED BY 'OPEN-IPCAMERA' TO CREATE UPGRADE PATCHES **#" >> $PATHSCRIPTS/version.txt
echo '' >> $PATHSCRIPTS/version.txt
echo "$VERSIONINSTALLED" >> $PATHSCRIPTS/version.txt

# Set perms on *version.txt* to immutable so it cannot be deleted- inadvertently or intentionally
chown pi:pi $PATHSCRIPTS/version.txt
chatter +i $PATHSCRIPTS/version.txt



echo
echo "$(tput setaf 5)****** Backup and Encrypt *variables.sh* File: ******$(tput sgr 0)"
echo

./backup_variables.sh_file.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo
echo "$(tput setaf 5)****** CREATE *upgrade_open-ipcamera.sh* SCRIPT: ******$(tput sgr 0)"
echo

# NOTE: This section only *CREATES* the upgrade script- it does nothing upgrade anything
./upgrade_open-ipcamera.sh 2>> $PATHLOGINSTALL/install.log&
wait $!


cp -p ./PubKey_terrence.houlahan_at_open-ipcamera.net_KeyID_FE5A1DE67F98FA66F.asc $PATHSCRIPTS/

# Delete open-ipcamera repo files:
rm -rf $PATHINSTALLDIR

echo
echo 'Deleted * open-ipcamera * Repo Directory'
echo

# Change ownership of all files created by this script FROM user *root* TO user *pi*:
chown -R pi:pi /home/pi




echo
echo
echo "$(tput setaf 1)** WARNING: REMEMBER TO CONFIGURE FIREWALL RULES TO RESTRICT ACCESS TO YOUR CAMERA ** $(tput sgr 0)"
echo
read -p 'Press * Enter * to execute an upgrade and reboot the Pi after reviewing open-ipcamera install script feedback'
echo


echo
echo "$(tput setaf 5)****** apt-get upgrade and dist-upgrade: ******$(tput sgr 0)"
echo

./os-upgrade.sh 2>> $PATHLOGINSTALL/install.log&
wait $!



echo 'System will reboot in 10 seconds'
sleep 10

systemctl reboot
