### Added by Zinit's installer
if [[ ! -f $HOME/.config/zsh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.config/zsh/.zinit" && command chmod g-rwX "$HOME/.config/zsh/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.config/zsh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.config/zsh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

source "$ZDOTDIR/zinit.zsh"

# anyframe
zstyle ":anyframe:selector:" use fzf
bindkey '^b' anyframe-widget-checkout-git-branch
bindkey '^g' anyframe-widget-cd-ghq-repository

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# asdf
if [[ -f /usr/local/opt/asdf/asdf.sh ]]; then
  . /usr/local/opt/asdf/asdf.sh
  fpath=(
    /usr/local/etc/bash_completion.d/asdf.bash
    $fpath
  )
fi

# kubernetes
if [[ $commands[kubectl] ]]; then
  alias k='kubectl'
fi
if [[ -f /usr/local/opt/kube-ps1/share/kube-ps1.sh ]]; then
  set_kubeconfig () {
    export KUBECONFIG="$HOME/.kube/config"
  }
  kon () {
    source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
    RPS1='$(kube_ps1)'
    set_kubeconfig
  }
  koff () {
    export KUBECONFIG="$HOME"
    RPS1=
  }
  koff
fi

# starship
if [[ $commands[starship] ]]; then
  eval "$(starship init zsh)"
fi

# gettext
if [[ -d /usr/local/opt/gettext/bin ]]; then
  export PATH="/usr/local/opt/gettext/bin:$PATH"
fi

# completion
COMPLETION_DIR=~/.config/zsh/completion
if [[ ! -d $COMPLETION_DIR ]]; then
  mkdir -p $COMPLETION_DIR
fi
if [[ $commands[eksctl] ]] && [[ ! -f $COMPLETION_DIR/_eksctl ]]; then
  eksctl completion zsh > $COMPLETION_DIR/_eksctl
fi
if [[ $commands[helm] ]] && [[ ! -f $COMPLETION_DIR/_helm ]]; then
  helm completion zsh > $COMPLETION_DIR/_helm
fi
fpath=($COMPLETION_DIR $fpath)

autoload -U compinit
compinit

# load local settings
if [[ -f $ZDOTDIR/.zshrc.local ]]; then
  source $ZDOTDIR/.zshrc.local
fi

