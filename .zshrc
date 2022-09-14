# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_DISABLE_RPROMPT=true
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
#PS1="[サイト19\$] \w: "

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
alias update='sudo nala upgrade && sudo flatpak -y update'
alias dotfiles=' cd /media/mahalo/Toxic/linuxbackup/dotfiles'
alias cl='clear'
alias goarchon='ssh root@192.168.1.113'
### Plugins ###
plugins=(git zsh-autosuggestions python)






source $HOME/.cargo/env
source $ZSH/oh-my-zsh.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mahalo/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mahalo/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/mahalo/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mahalo/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

