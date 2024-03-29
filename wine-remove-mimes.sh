#!/bin/bash
# Workaround for winemenubuilder bloating file associations by default

# Remove all existing associations
rm -f ~/.local/share/mime/packages/x-wine*
rm -f ~/.local/share/applications/wine-extension*
rm -f ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*
rm -f ~/.local/share/mime/application/x-wine-extension*

# Disable winemenubuilder for all existing registries
# Replace ~/.bottles with your prefix/"bottle" directories
