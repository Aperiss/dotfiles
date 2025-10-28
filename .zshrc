# Shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

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

# Emacs daemon aliases
alias emacs='emacsclient -c -a ""'

# Completion styling 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --oneline --all --color=always --icons=always $realpath'

export UE4_ROOT="$HOME/dev/UE4"
export CARLA_UNREAL_ENGINE_PATH="$HOME/dev/UE5"

# Add Doom Emacs to PATH
export PATH="$HOME/.config/emacs/bin:$PATH"

# Add Zig to PATH
export PATH="/usr/local/zig:$PATH"

# Add Go binaries to PATH
export PATH="$HOME/go/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
