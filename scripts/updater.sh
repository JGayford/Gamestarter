#!/bin/bash

ADDON_DIRECTORY=/storage/.kodi/addons/script.gamestarter/
# Script for checking for updates 
kodi-send --action=Notification"(Gamestarter,Checking for updates...,4000,/storage/.kodi/addons/script.gamestarter/icon.png)"

# comprobar que changelog de internet y local son iguales
wget --no-check-certificate -O $ADDON_DIRECTORY/changelog_latest.txt https://raw.githubusercontent.com/bite-your-idols/Gamestarter-Pi/master/script.gamestarter/changelog.txt
VERSION_LOCAL=$(head -c 6 $ADDON_DIRECTORY/changelog.txt) 
VERSION_ONLINE=$(head -c 6 $ADDON_DIRECTORY/changelog_latest.txt) 
echo $VERSION_LOCAL
echo $VERSION_ONLINE


if [[ $VERSION_LOCAL == $VERSION_ONLINE ]]
then
   # echo "Gamestarter is up to date"
   kodi-send --action=Notification"(Gamestarter,Gamestarter is up to date,6000,/storage/.kodi/addons/script.gamestarter/icon.png)"
else
   # echo "There is a new version you can download"
   kodi-send --action=Notification"(Gamestarter,Uploading...,6000,/storage/.kodi/addons/script.gamestarter/icon.png)"
   #sacar solo los valores de la version p.e. "2.3"
   VERSION_UPDATE=$(head -c 4 $ADDON_DIRECTORY/changelog_latest.txt) 
   VERSION_UPDATE=$(tail -c 5 $VERSION_UPDATE)
   #sacar la veriosnd el addon OLE/LE8alpha -> habria que meterla en installed al instalar
   VERSION_ADDON=$(head -c 8 $ADDON_DIRECTORY/resources/bin/installed)
   #asi sabemos que version del zip descargar
   wget --no-check-certificate -O /storage/gamestarter-update.zip https://github.com/bite-your-idols/Gamestarter-Pi/releases/download/$VERSION_UPDATE/script.gamestarter-v$VERSION_UPDATE-$VERSION_ADDON.zip
   unzip /storage/gamestarter-update.zip -d /storage/gamestarter-update
   # movemos la carpeta del addon nueva y nos aseguramos que sobreescribe lo que tiene que sobreescribir
   mv /storage/gamestarter-update/script.gamestarter /storage/.kodi/addons/
   # habria que copiar las carpetas y archivos en su sitio
   
   #forzamos la reinstalacion al iniciar el addon
   rm $ADDON_DIRECTORY/resources/bin/installed
   #borramos la carpeta de archivos de actualizacion
   #rm -rx /storage/gamestarter-update
fi

rm $ADDON_DIRECTORY/changelog_latest.txt
