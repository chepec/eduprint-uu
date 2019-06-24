#!/bin/bash
#
# Install script for eduPrint-SMB on Linux
# (c) 2018, 2019 Staffan Emrén, Uppsala University
#
# This script is licensed under GPL v 2, the complete
# license terms can be found on the following link:
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
#
# Based on the script for installing eduPrint-SMB on Mac
#
# v 0.1
#  First version, building and testing scripted install with lpadmin
#
# v 0.2
#  Added check for root priviligies
#
# v 0.3
#  Added help text and an option for printer name
#
# v 0.4
#   Removed check for root priviligies and instead prepended lpadmin with sudo
#
# v 0.5
#   Added correct eduPrint finisher to the lpadmin command
#
# v 1.0
#   Added lpadmin options to get correct authentication behaviour
#   Added installation of Ricoh driver package in the script
#
# v 1.1
#   Added an "other" option on distro check and some cleanup
#   Added a check wether the lsb_release command exists on the system

# Name and path of ppd file
PPD_FILE="./eduPrint_Linux_Ricoh_MP_C5504ex_PS.ppd"

if [ "$1" = "-v" ] ; then
  echo -e "install-eduprint version 1.1\n2019-06-19"
  exit 1
fi

if [ "$1" = "-h" ] ; then
  echo "Usage: eduprint-install.sh [-n "desired printer name"]"
  exit 1
fi

# You can optionally set a printer name of your choise
# If not set, it defaults to eduPrint-UU
if [ "$1" = "-n" ] ; then
  PRINTER_NAME="$2"
else
  PRINTER_NAME="eduPrint-UU"
fi

# We need to know what distribution we are running and thus what package manager is used
# on this system, so we can check for and install the requirements. This is done with
# the command lsb_release, if it is not present on the system we must exit.
#
# CentOS 7 does not ship with lsb_release installed, thus we must in that case check if
# this might be CentOS

if which lsb_release >/dev/null 2>/dev/null ; then
  DISTRO=$(lsb_release -i | sed 's/.*:.//')
elif cat /etc/system-release-cpe 2>/dev/null | grep centos >/dev/null 2>/dev/null ; then
  DISTRO="CentOS"
else
  echo "Can't find your Linux distribution, please install manually"
  echo "Looking at this script might be useful."
  exit 5
fi

case "$DISTRO" in
  "RedHat" | "CentOS" | "ScientificLinux")
    PKG_MAN="yum"
    ;;
    
  "Ubuntu" | "Debian")
    PKG_MAN="apt-get"
    ;;

  *)
    echo "Your Linux distribution is unsupported."
    echo " "
    echo "If your distribution uses either yum or apt-get"
    echo "for package management we can still try to "
    echo "install dependencies automatically."
    echo " "
    echo "Otherwise you will have to do a manual install."
    echo "Looking at this script might be useful."
    echo " "
    echo "Enter y for yum, a for apt-get or o for other."
    read ANSWER
    case "$ANSWER" in
      y)
        PKG_MAN="yum"
        ;;

      a)
        PKG_MAN="apt-get"
        ;;
      
      *)
        echo "Exiting, please install manually."
        exit 2
        
    esac
esac

# Make sure smbclient and foomatic are installed
case $PKG_MAN in
  "yum" )
    sudo yum -y -q install samba-client foomatic
    # Check that the packages got installed
    if ! sudo rpm --query --queryformat "" samba-client foomatic ; then
      echo "At least one of the dependencies was not installed"
      echo "Please install manually. Looking at this script might be useful."
      exit 5
    fi
    ;;

  "apt-get" )
    if ! sudo apt-get -qq install smbclient foomatic-db-compressed-ppds ; then
      echo "At least one of the dependencies was not installed"
      echo "Please install manually. Looking at this script might be useful."
      exit 5
    fi
    ;;

esac

# Now we add the printer
sudo lpadmin -p "$PRINTER_NAME" -v smb://edp-uu-prn01.user.uu.se/eduPrint-UU -i "$PPD_FILE" -o printer-is-shared=false -o printer-op-policy=authenticated -o auth-info-required=username,password -o ColorModel=Gray -o Finisher=FinRUBICONB -o RIPostScript=Adobe -u allow:all -E

echo " "
echo "Printer $PRINTER_NAME was successfully installed"
echo " "

# Done! :)
