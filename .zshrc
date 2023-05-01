# prompt setting

## curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
source ~/.zsh/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=auto

setopt PROMPT_SUBST ; PS1='
%F{green}%~%f %F{cyan}$(__git_ps1 "(%s)")%f
\$ '

## curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fpath=(~/.zsh $fpath)

## curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
