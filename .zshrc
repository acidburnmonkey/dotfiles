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
export XDG_RUNTIME_DIR=/run/user/$(id -u)


ZSH_THEME="powerlevel10k/powerlevel10k"


# some more ls aliases
alias update='sudo dnf update && sudo flatpak -y update'
alias lion=' cd ~/Nextcloud/School/cppclass/clion/'
alias cl='clear'
alias goarchon='ssh root@192.168.1.118'
alias src='source ~/.zshrc'
alias neogit='onefetch'
alias grub2-update='sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
alias vim='nvim'
alias xc='xclip -sel clip'
alias pycheck='python -m pylint --disable=R,C'
alias goadum='ssh mal0@192.168.1.146'

### Plugins ###
plugins=(git zsh-autosuggestions python virtualenv)

function cd {
    builtin cd "$@" && ls -F
}

function .. {
    builtin cd .. "$@" && ls -F
}


source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

