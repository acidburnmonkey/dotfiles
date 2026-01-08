#!/bin/bash

if hyprctl clients | grep -q "chrome-calendar.google.com__calendar_u_0_r-Profile_1"; then
    # Get the PID and kill it
    pid=$(hyprctl clients | grep -A 20 "chrome-calendar.google.com__calendar_u_0_r-Profile_1" | grep "pid:" | awk '{print $2}')
    if [[ -n $pid ]]; then
        kill $pid
    fi
else
    chromium-browser --profile-directory="Profile 1" --app=https://calendar.google.com/calendar/u/0/r &
fi
