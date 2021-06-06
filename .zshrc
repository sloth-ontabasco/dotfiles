# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  docker-compose
  z
  zsh-syntax-highlighting
  history-substring-search
  command-not-found
  copydir
  copyfile
  dircycle
  vi-mode
  jira
)

ENABLE_CORRECTION="true"

source $ZSH/oh-my-zsh.sh
. ~/z.sh

if [[ -r ~/.phpbrew/bashrc ]]; then
  source ~/.phpbrew/bashrc
fi

alias n='neovide'
alias install='sudo pacman -S'
alias search='sudo pacman -Ss'
alias remove='sudo pacman -R'
alias update='sudo pacman -Sy'
alias yinstall='yay -S'
alias ysearch='yay -Ss'
alias yremove='yay -R'
alias yupdate='yay -Sy'
alias l="ls -lah"
alias c="clear"
alias code="cd ~/Projects/"
alias lg="lazygit"
alias resetbg="colors"
alias togglebg="colors toggle"

export PATH=$PATH:/usr/local/go/bin:~/go/bin:~/.local/bin
export LESS=R
export EDITOR=nvim
export MANPAGER="nvim -c 'set ft=man' -"
export FZF_DEFAULT_COMMAND='rg --files'
export LESS=R
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=magenta,bold,underline"
setopt HIST_IGNORE_ALL_DUPS

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
# zsh-autosuggestions is designed to be unobtrusive)
NVIM_BG=${NVIM_COLORSCHEME_BG:-'light'}
if [ $NVIM_BG = 'dark' ]; then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
else
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=249'
fi
export KEYTIMEOUT=1

[ -f ~/.zsh_secret ] && source ~/.zsh_secret

export NVM_DIR="/home/kristijan/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


bindkey '^[[Z' reverse-menu-complete # Use shift tab for backward autocompletion

function zle-keymap-select zle-line-init zle-line-finis
{
  case $KEYMAP in
      vicmd)      print -n '\033[1 q';; # block cursor
      viins|main) print -n '\033[5 q';; # line cursor
  esac
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

### Bind up and down keys for history-substring-search plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
### Source: https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

### Custom FZF functions
### @see: https://github.com/junegunn/fzf/wiki/examples
# Open link from Chrome history
chr() {
  local cols sep google_history
  cols=$(( COLUMNS / 3 ))
  sep='{::}'
  google_history="$HOME/.config/google-chrome/Default/History"

  cp -f "$google_history" /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs xdg-open > /dev/null 2> /dev/null
}

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

colors() {
  color_vars=$(~/neovim-config/colors $1)
  eval ${color_vars}
}

# Autocomplete Z items
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
