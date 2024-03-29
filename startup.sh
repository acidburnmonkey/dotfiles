#!/bin/bash

sleep 5 
pkill openrgb

#poltit
exec nohup /usr/libexec/polkit-gnome-authentication-agent-1 &

#map caps to esc
setxkbmap -option "caps:escape"

#set screen blck to 1:40h
xset s noblank && xset s 5400
xset -dpms
#remove photoshop garbage files
rm ~/Photoshop_*.log 
rm ~/sniffer_*.log
rm ~/CEPHtmlEngine*
###############

