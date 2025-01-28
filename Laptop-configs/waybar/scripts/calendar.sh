#!/bin/bash

if [[ -z $(pgrep gnome-calendar) ]]; then
    gnome-calendar
else
    pkill gnome-calendar
fi

