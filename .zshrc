# Prompt line: Starship
eval "$(starship init zsh)"


# ===== Hiztory =====

HISTSIZE=10000
HISTFILE=~/.histfile
SAVEHIST=$HISTSIZE
HISTDUP=erase


# ===== Keybindings =====

bindkey -e                               # Set key bindings. Emacs -e, Vim -v
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward

bindkey '^T' fzf-completion


# ===== Options =====

setopt CORRECT # Enable typo correction

# Adition history opt
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY # save cmd times
setopt hist_ignore_space
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS


# ===== Hyprland =====

if [ "$(tty)" = "/dev/tty1" ]; then
    start-hyprland
fi


# ===== Aliases =====

alias ll='ls -Alh --color=auto'
alias grep='grep --colour=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

alias mpv_hdr='mpv --vo=gpu-next --target-colorspace-hint --gpu-api=vulkan --gpu-context=waylandvk'
alias v='nvim'

# Tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# Kubernetes
alias kns='kubectl config set-context --current --namespace'

# Git
alias gt='git'
alias ga='git add'
alias gc='git commit -m'
alias gs='git status'
alias glog='git log --oneline --graph --all'


# ===== Programs options =====

# Paths
export PATH="$PATH:/usr/local/go/bin"
export PATH="/home/glen/.local/bin:$PATH"

# Editor
export EDITOR=nvim
export VISUAL=nvim

# PASS 
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR=$XDG_DATA_HOME/password-store/.extensions

# Ranger
export RANGER_LOAD_DEFAULT_RC=FALSE

# Fix ls color for folders with 777 permissions
export LS_COLORS="$LS_COLORS:ow=30;44:"

# PAGER
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
export LESS_TERMCAP_md=$(tput bold; tput setaf 1)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_ue=$(tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 2)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export MANPAGER='less'

# ===== Yazi =====

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# ===== Plugins =====

# fzf
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
    --scheme=history
    --color header:italic"
export FZF_DEFAULT_OPTS="--height 40% \
    --bind 'ctrl-/:toggle-preview'
    --layout=reverse \
    --style default \
    --highlight-line \
    --info=inline-right \
    --layout=reverse \
    --border=none \
    --color=bg+:#283457 \
    --color=bg:#16161e \
    --color=border:#27a1b9 \
    --color=fg:#c0caf5 \
    --color=gutter:#16161e \
    --color=header:#ff9e64 \
    --color=hl+:#2ac3de \
    --color=hl:#2ac3de \
    --color=info:#545c7e \
    --color=marker:#ff007c \
    --color=pointer:#ff007c \
    --color=prompt:#2ac3de \
    --color=query:#c0caf5:regular \
    --color=scrollbar:#27a1b9 \
    --color=separator:#ff9e64 \
    --color=spinner:#ff007c
"

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
        export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview 'bat -n --color=always --style=numbers {}' "$@" ;;
    esac
}

source <(fzf --zsh)

# zsh-suggestions
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=black,fg=green,bold,underline'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-completions
source ~/.zsh/zsh-completions/zsh-completions.plugin.zsh

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle :compinstall filename "$HOME/home/glen/.zshrc"

complete -C '/usr/local/bin/aws_completer' aws # AWS

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
