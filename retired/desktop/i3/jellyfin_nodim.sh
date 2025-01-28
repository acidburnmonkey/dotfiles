#!/bin/bash 

xset s off 

flatpak run --branch=stable --arch=x86_64 --command=jellyfinmediaplayer com.github.iwalton3.jellyfin-media-player --windowed  --desktop "@"

xset s on
