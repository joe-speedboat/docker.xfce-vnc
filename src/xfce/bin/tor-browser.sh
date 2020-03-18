#!/bin/bash

ADIR=$HOME/.local/share/applications
PDIR=$HOME/bin
TURL="https://dist.torproject.org$(curl -s https://www.torproject.org/download/ | grep linux | grep download | sed 's/.*href=..dist//' | cut -d\" -f1 )"
TFILE="tor-browser_en-US.tar.xz"

cd
test -d $PDIR || mkdir $PDIR
cd $PDIR
test -d tor-browser_en-US
if [ $? -ne 0 ]
then
   curl -s $TURL -o $TFILE
   tar xf $TFILE
   rm -f $TFILE

   test -d $ADIR || mkdir -p $ADIR
   mkdir -p $ADIR
   ICON="$ADIR/tor-browser.desktop"
   echo '[Desktop Entry]' > $ICON
   echo 'Type=Application' >> $ICON
   echo 'Name=Tor Browser Setup' >> $ICON
   echo 'Categories=Network;WebBrowser;Security;' >> $ICON
   echo "Exec=$HOME/bin/tor-browser.sh" >> $ICON
   echo 'Icon=web-browser' >> $ICON
fi
exec $HOME/bin/tor-browser_en-US/Browser/start-tor-browser --detach
