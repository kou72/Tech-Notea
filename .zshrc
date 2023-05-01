# prompt setting

## curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
source ~/.zsh/git-prompt.sh

# addされていない変更を「*」commitされていない変更を「+」で示す
GIT_PS1_SHOWDIRTYSTATE=true
# addされていない新規ファイルの存在を「%」で示す
GIT_PS1_SHOWUNTRACKEDFILES=true
# stashがある場合は「$」で示す
unset GIT_PS1_SHOWSTASHSTATE
# upstreamと同期「=」進んでいる「>」遅れている「<」で示す
GIT_PS1_SHOWUPSTREAM=auto

setopt PROMPT_SUBST

function git_color() {
  local git_info="$(__git_ps1 "%s")"
  if [[ $git_info == *"%"* ]] || [[ $git_info == *"*"* ]]; then
    echo '%F{red}'
  elif [[ $git_info == *"+"* ]]; then
    echo '%F{green}'
  else
    echo '%F{cyan}'
  fi
}

PS1='
%F{magenta}%~%f %F{yellow}$(__git_ps1 "[")%f$(git_color)$(__git_ps1 "%s")%f%F{yellow}$(__git_ps1 "]")%f
\$ '

## curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
fpath=(~/.zsh $fpath)

## curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# suggests commands
## git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY
