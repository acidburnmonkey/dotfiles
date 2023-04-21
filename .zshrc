if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR='nvim'
export VISUAL='nvim'
export PATH="$HOME/scripts:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
export PYTHONUNBUFFERED=1

ZSH_THEME="powerlevel10k/powerlevel10k"


# some more ls aliases
alias update='sudo dnf update && sudo flatpak -y update'
alias dotfiles=' cd repos/dotfiles'
alias lion=' cd ~/Nextcloud/School/cppclass/clion/'
alias cl='clear'
alias goarchon='ssh root@192.168.1.118'
alias src='source ~/.zshrc'
alias neogit='onefetch'
alias grub2-update='sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
alias vim='nvim'
alias xc='xclip -sel clip'
alias pycheck='python -m pylint --disable=R,C'

### Plugins ###
plugins=(git zsh-autosuggestions python virtualenv)

function cd {
    builtin cd "$@" && ls -F
}

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
