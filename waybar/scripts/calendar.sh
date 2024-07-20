#!/bin/bash

if [[ -z $(pgrep gnome-calendar) ]]; then
    flatpak run org.gnome.Calendar
else
    pkill gnome-calendar
fi

