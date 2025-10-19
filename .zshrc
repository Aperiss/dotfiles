# Shell integrations
eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

source ~/.config/zsh/scripts/tmux_launcher.sh

if [[ -f "/opt/homebrew/bin/brew" ]] then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Aliases
alias ls='eza --oneline --color=always --icons=always'
alias la='eza --oneline --all --color=always --icons=always'
alias li='eza --oneline --all --git-ignore --color=always --icons=always'
alias l.='ls -d .*'

alias lt='eza --tree --color=always --icons=always'

alias ll='eza --all --header --long --no-time --color=always --icons=always'
alias lli='eza --all --header --long --no-time --git-ignore --color=always --icons=always'

alias llm='eza --all --header --long --reverse --sort=modified --color=always --icons=always'
alias llmi='eza --all --header --long --git-ignore --reverse --sort=modified --color=always --icons=always'

# Completion styling 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --oneline --all --color=always --icons=always $realpath'

# Add doom emacs to PATH
export PATH="$PATH:/Users/aperiss/.config/emacs/bin"

# Emacs function to open with files/directories
emacs() {
    if [ $# -eq 0 ]; then
        open -a emacs
    else
        open -a emacs "$@"
    fi
}
