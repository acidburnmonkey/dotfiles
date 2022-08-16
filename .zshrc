# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

PS1="[サイト19\$] \w: "

##### Converts APT and sudo to nala 
  apt() { 
    command nala "$@"
  }
  sudo() {
    if [ "$1" = "apt" ]; then
      shift
      command sudo nala "$@"
   else
      command sudo "$@"
   fi
  }
 #############
 

# some more ls aliases
alias l='ls -CF'
alias update='sudo apt update && sudo apt upgrade && sudo flatpak update'
alias dotfiles=' cd /media/mahalo/Toxic/linuxbackup/dotfiles'
alias cl='clear'


plugins=(git)

source $ZSH/oh-my-zsh.sh

