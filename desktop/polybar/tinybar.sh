#!/usr/bin/env bash
# script to Tiny-launch polybar


echo "---" | tee -a /tmp/polybar2.log
polybar tray >> /tmp/polybar2.log 2>&1
