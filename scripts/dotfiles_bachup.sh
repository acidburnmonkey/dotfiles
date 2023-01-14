#!/bin/bash


#zhrc
cp -r -u -v ~/.zshrc ~/repos/dotfiles

#kitty
cp -r -u -v ~/.config/kitty ~/repos/dotfiles

#ulauncher
cp -r -u -v ~/.config/ulauncher ~/repos/dotfiles

#libreoffice
cp -r -u -v ~/.config/libreoffice ~/repos/dotfiles

#neofetch
cp -r -u -v ~/.config/neofetch ~/repos/dotfiles

# Cinnamon configs
cp -r -u -v ~/cinnamon-configs ~/repos/dotfiles

# Nvim
cp -r -u -v ~/.config/nvim ~/repos/dotfiles

echo "All Done"
