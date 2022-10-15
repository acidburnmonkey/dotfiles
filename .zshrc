# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_DISABLE_RPROMPT=true
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)

# some more ls aliases
alias update='sudo dnf -y  update && sudo flatpak -y update'
alias dotfiles=' cd /media/Toxic/linuxbackup/dotfiles'
alias cl='clear'
alias goarchon='ssh root@192.168.1.118'
### Plugins ###
plugins=(git zsh-autosuggestions python)



source $ZSH/oh-my-zsh.sh


