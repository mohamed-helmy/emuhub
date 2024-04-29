#!/bin/bash

# a variety of .desktop files magically appear when we launch OpenBox 
# but some of these are broken or distracting for users, so nuke 'em
#
#rm /usr/share/applications/display-im6.q16.desktop 
#rm /usr/share/applications/display-im6.desktop 
rm /usr/share/applications/deluge.desktop
rm /usr/share/menu/deluge*
rm /usr/share/applications/lxterminal.desktop 
rm /usr/share/applications/debian-uxterm.desktop 
rm /usr/share/applications/x11vnc.desktop 
# rm /usr/share/applications/lxde-x-www-browser.desktop 
# ln -s /usr/share/applications/firefox.desktop /usr/share/applications/lxde-x-www-browser.desktop 
# rm /usr/share/applications/lxde-x-terminal-emulator.desktop  
rm -rf /usr/share/ImageMagick-6
rm /usr/share/applications/redhat*
rm /usr/share/applications/deluge*
#rm /usr/share/applications/debian*
rm /usr/share/applications/clipt
#rm /usr/share/applications/org.freedesktop*
#rm /usr/share/applications/org.gnome*
rm /usr/share/applications/gnome*
#rm /usr/share/applications/exo*
#rm /usr/share/applications/evo*
rm /usr/share/applications/geo*
rm /usr/bin/lxpolkit
#rm /usr/bin/clipit


