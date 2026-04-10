#!/usr/bin/env bash
# Toggle the network widget: launch if not running, kill if running.

WIDGET="$(dirname "$(realpath "$0")")/networkWidget.qml"

if pgrep -f "quickshell -p.*networkWidget.qml" > /dev/null 2>&1; then
    pkill -f "quickshell -p.*networkWidget.qml"
else
    quickshell -p "$WIDGET" &
fi
