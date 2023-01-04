# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_DISABLE_RPROMPT=true
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)

# some more ls aliases
alias update='sudo dnf update && sudo flatpak -y update'
alias dotfiles=' cd repos/dotfiles'
alias cl='clear'
alias goarchon='ssh root@192.168.1.118'
alias src='source ~/.zshrc'
alias neogit='onefetch'
alias grub2-update='sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
alias vim='nvim'

### Plugins ###
plugins=(git zsh-autosuggestions python)

function cd {
    builtin cd "$@" && ls -F
}

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
