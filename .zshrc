if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_DISABLE_COMPFIX="true" #root comp
ZSH_THEME="powerlevel10k/powerlevel10k"
#
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export EDITOR='nvim'
export VISUAL='nvim'
export PATH="$HOME/scripts:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
export PYTHONUNBUFFERED=1
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export PATH="$HOME/.cargo/bin:$PATH"
export QT_QPA_PLATFORMTHEME=qt5ct
export SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent.socket
export $(dbus-launch)
export DOCKER_HOST=unix:///var/run/docker.sock

# some more ls aliases
alias update='sudo dnf update && sudo flatpak -y update'
alias cl='clear'
alias goarchon='ssh root@192.168.1.118'
alias src='source ~/.zshrc'
alias neogit='onefetch'
alias update-grub='sudo grub2-mkconfig -o /boot/grub2/grub.cfg & grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg'
alias vim='nvim'
alias xc='wl-copy'
alias goadum='ssh -x mal0@192.168.1.146'
alias zz='python $HOME/scripts/devmode.py'
alias docker-compose='docker compose'
alias ranger='source ranger'
alias dps='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a'
alias sr='source .venv/bin/activate'
alias ncdu='ncdu --color dark'

### Plugins ###
plugins=(git zsh-autosuggestions python virtualenv fzf)

function cd {
    builtin cd "$@" && ls -F
}

function .. {
    builtin cd .. "$@" && ls -F
}

function man {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $HOME/repos/fzf-git.sh/fzf-git.sh


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

alias virsh='virsh -c qemu:///system'
