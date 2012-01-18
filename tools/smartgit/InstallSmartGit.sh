#! /bin/bash
# script to collect all my cloud DNS configuration into this directory.
#
export ADMIN_USERZ_UID=yourself
export ADMIN_USERZ_HOME=/home/$ADMIN_USERZ_UID
export ADMIN_USERZ_WORK_DIR=/home/$ADMIN_USERZ_UID/tmp
#
export JENKINS_USERZ_UID=yourself
export JENKINS_USERZ_HOME=/home/$JENKINS_USERZ_UID
#
# Initiate downloading the installers we're going to need.
cd ${INS}
LOCAL_MIRROR=http://openerpns.warehouseman.com/downloads
# Obtain Syntevo SmartGit
SRV_SYNTEVO="http://www.syntevo.com"
#wget -cNb --output-file=dldJdk.log ${SRV_SYNTEVO}/download/smartgit/smartgit-generic-2_1_6.tar.gz
sudo rm -f dldSmartgit.log*
echo "Obtaining SmartGit.."
wget -cNb --output-file=dldSmartgit.log ${LOCAL_MIRROR}/smartgit-generic-2_1_6.tar.gz
#
${PRG}/installTools/waitForCompleteDownload.sh -d 3600 -l ./dldSmartgit.log -p smartgit-generic
#
export SYNTEVO_HOME=${PRG}/com/syntevo
sudo mkdir -p ${SYNTEVO_HOME}
cd ${SYNTEVO_HOME}
echo "Expanding SmartGit.."
sudo tar zxvf ${INS}/smartgit-generic-2_1_6.tar.gz
echo "Symlinking SmartGit.."
sudo ln -s smartgit-2_1_6 smartgit
export SMARTGIT_HOME=${SYNTEVO_HOME}/smartgit
sudo chown -R yourself:yourself ${PRG}
#
sudo aptitude -y update
sudo aptitude -y upgrade
#
sudo aptitude -y install ssh-askpass
#
sudo aptitude -y update
sudo aptitude -y upgrade
#
sudo rm -f $JENKINS_USERZ_HOME/.ssh/id_rsa
echo -e "\n\n\n" | sudo ssh-keygen -t rsa -f $JENKINS_USERZ_HOME/.ssh/id_rsa
#
sudo usermod -a -G $ADMIN_USERZ_UID $JENKINS_USERZ_UID
sudo chmod 750 $JENKINS_USERZ_HOME/.ssh
sudo chmod 640 $JENKINS_USERZ_HOME/.ssh/id_rsa
#
echo "Creating panel button.."
#
cd ${PRG}/installTools
#
wget -cN ${SRV_CONFIG}/tools/InsertInFile.sh
chmod +x ./InsertInFile.sh
#

PANEL_CONFIG=${ADMIN_USERZ_HOME}/.config/lxpanel/LXDE/panels
# TOP_PANEL_CONFIG=${ADMIN_USERZ_HOME}/.config/lxpanel/LXDE/panels/top
cd ${ADMIN_USERZ_WORK_DIR}
#
LAUNCHER=smartgit.desktop
APPLICATIONS=/usr/share/applications
#
wget -cN ${SRV_CONFIG}/tools/smartgit/$LAUNCHER
sudo chown root:root $LAUNCHER
sudo chmod 644 $LAUNCHER
sudo mv $LAUNCHER $APPLICATIONS
#
cp $PANEL_CONFIG/top .

INSERTION="    Button \{\n            id=$APPLICATIONS/$LAUNCHER\n        }\n    "
EOF_MARKER="\}"
FILE=top
${PRG}/installTools/InsertInFile.sh -i "${INSERTION}" -s "${EOF_MARKER}" -f ${FILE}

rm -f ./top
mv ./top.new $PANEL_CONFIG/top

tail -n 25  $PANEL_CONFIG/top
ls -l
ls -l $APPLICATIONS/sma*
exit 0;

