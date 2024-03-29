#!/bin/bash

dotfiles="$HOME/repos/dotfiles/"

#zhrc
cp -r -u -v ~/.zshrc  $dotfiles
#.p10k.zh
cp -r -u -v ~/.p10k.zsh $dotfiles

#kitty
cp -r -u -v ~/.config/kitty $dotfiles
#ulauncher
cp -r -u -v ~/.config/ulauncher $dotfiles
#neofetch
cp -r -u -v ~/.config/neofetch $dotfiles
# Nvim
cp -r -u -v ~/.config/nvim $dotfiles


#desktop ---------
#i3 
cp -r -u -v ~/.config/i3 ~/repos/dotfiles/desktop/
#polybar
cp -r -u -v ~/.config/polybar ~/repos/dotfiles/desktop/
#picom
cp -r -u -v ~/.config/picom.conf ~/repos/dotfiles/picom.conf



echo "All Done"
