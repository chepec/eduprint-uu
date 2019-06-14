#!/bin/bash
#
# Skript för att installera eduPrint på en icke-ad-ansluten linuxdator
#
# (c) 2017 Staffan Emrén, Uppsala universitet
# Licensierad under GPL v2
#
# version 0.9 2017-09-29
#   Första användbara version, endast på svenska
#
# version 1.0 2017-10-09
#   Presenterar meddelande på svenska endast om utdatat
#   från kommandot locale innehåller sv_SE, annars
#   presenteras alla meddelanden på engelska.
#   Presenterar versionsmeddelande om växeln -v eller
#   --version anges, vilken annan växel som helst 
#   växlar till avlusningsläge, vilket innebär att
#   inget installeras.
#
# version 1.0.1 2017-09-10
#   Fixat två typos som Eric Stempels hittad
#
# version 1.0.2 2017-11-01
#   Egentligen ingen ny version av skriptet, men
#   paketerat med en uppdaterad PPD-fil som automatiskt
#   skalar om "fel" pappersstorlek. På det sättet
#   slipper vi utskrifter som försvinner i skrivaren
#   på grund av att de inte är A3 eller A4.
# 
# added to https://github.com/chepec/eduprint-uu
#   see the github repo's history for change history

# För att underlätta avlusning av nya versioner
DEBUG="$1"

if [ "$DEBUG" == "-v" ] || [ "$DEBUG" == "--version" ] ; then
  echo "install-eduprint-client version 1.0.1"
  echo "(c) 2017 Staffan Emrén"
  echo "Licenced under GPL v2"
  exit 1
elif [ "$DEBUG" ] ; then
  echo "Entering debug mode"
fi

# Ska vi prata svenska eller engelska?
PREFERRED_LANGUAGE=$(locale | grep -e 'LC_MESSAGES=.sv_SE' )
if [ "$PREFERRED_LANGUAGE" == "" ] ; then
  LANG=0
else
  LANG=1
fi

# Meddelanden
MSG_NO_ROOT[0]="The install must be done as the root user or with sudo."
MSG_NO_ROOT[1]="Installationen måste köras som root eller med sudo."
MSG_FOLDER_EXIST[0]="The folder /usr/share/eduprint-client already exist, do you still want to continue? (y/n)"
MSG_FOLDER_EXIST[1]="Katalogen /usr/share/eduprint-client existerar redan, fortsätta ändå? (j/n)"
MSG_ABORT_INSTALL[0]="Aborting installation"
MSG_ABORT_INSTALL[1]="Avbryter installationen"
MSG_FINISHED[0]="Installation complete, what remains is to make shure that /usr/share/eduprint-client/pc-client-linux.sh is launched automatically on login. How this is done differs between linux distributions."
MSG_FINISHED[1]="Installationen är klar, det du behöver göra nu är att se till att /usr/share/eduprint-client/pc-client-linux.sh startas automatiskt när du loggar in. Hur detta görs skiljer sig mellan olika linuxdistributioner."

# För att köra resten av skriptet måste
# vi ha rooträttigheter. Låt oss kontrollera detta.
if [ $EUID -ne 0 ] ; then
  echo "${MSG_NO_ROOT[$LANG]}"
  exit 1
fi

# Skapa katalogen /usr/share/eduprint-client. Will be overwritten if it already exists. 
if [ $DEBUG ] ; then
  echo "mkdir /usr/share/eduprint-client"
else
  mkdir /usr/share/eduprint-client
fi

# Kopiera klienten till denna katalog
if [ $DEBUG ] ; then
  echo "cp -r linux/* /usr/share/eduprint-client"
else
  cp -r linux/* /usr/share/eduprint-client
fi

# Installera skrivaren
if [ $DEBUG ] ; then
  echo "lpadmin -p eduPrint-client -v lpd://edp-uu-mob01.user.uu.se/Public-UU -P eduPrint_UU_Linux_Ricoh_MP_C5504ex_PS.ppd -u allow:all -E"
else
  lpadmin -p eduPrint-client -v lpd://edp-uu-mob01.user.uu.se/Public-UU -P eduPrint_UU_Linux_Ricoh_MP_C5504ex_PS.ppd -u allow:all -E
fi

# Klart
echo "${MSG_FINISHED[$LANG]}"
exit 0
