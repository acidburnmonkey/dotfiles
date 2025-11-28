if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_DISABLE_COMPFIX="true" #root comp
ZSH_THEME="powerlevel10k/powerlevel10k"
#
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export EDITOR='nvim'
export VISUAL='nvim'
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PYTHONUNBUFFERED=1
export QT_QPA_PLATFORMTHEME=qt5ct
export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
export SSH_AUTH_SOCK=/run/user/$(id -u)/ssh-agent.socket
# export DOCKER_HOST=unix:///var/run/docker.sock
export NO_AT_BRIDGE=1 #disable accessibility
export GTK_A11Y=none

# some more ls aliases
alias update='sudo dnf update && flatpak -y update'
alias cl='clear'
alias src='source ~/.zshrc'
alias neogit='onefetch'
alias update-grub='grub2-mkconfig -o /boot/grub2/grub.cfg'
alias vim='nvim'
alias xc='wl-copy'
alias goadum='ssh -x mal0@192.168.1.209'
alias zz='python $HOME/scripts/devmode.py'
alias docker-compose='docker compose'
alias ranger='source ranger'
alias dps='docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}" -a'
alias sr='source .venv/bin/activate'
alias git-push='git remote | xargs -n1 git push'
alias ncdu='ncdu --color dark'

### Plugins ###
plugins=(git zsh-autosuggestions python virtualenv fzf)

function cd {
    builtin cd "$@" && ls -F
}

function .. {
    builtin cd .. "$@" && ls -F
}

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(uv generate-shell-completion zsh)"
