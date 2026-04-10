#!/usr/bin/env bash
# Toggle the audio widget

WIDGET="$(dirname "$(realpath "$0")")/audioWidget.qml"

if pgrep -f ".*audioWidget.qml" > /dev/null 2>&1; then
   pkill -f ".*audioWidget.qml" > /dev/null 2>&1
else
   quickshell -p "$WIDGET" &
fi
