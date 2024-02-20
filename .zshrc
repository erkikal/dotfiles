# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

autoload -Uz compinit
compinit

# aliases
source ~/.aliases 

# keybinding
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# functions
# Add privileges app request to sudo
function sudo() {
    local sudo_status=$(privilegescli --status 2>&1)

    if [[ $sudo_status == *"User $USER has standard user rights"* ]]; then
        privilegescli --add
    fi

    command sudo "$@"
}

# get local network interfaces IP addresses
function ip-addr (){
    for i in $(ifconfig -lu)
    do
        if ifconfig $i | grep -q "inet "
        then
            ifconfig $i
        fi
    done
}

# exports
export XDG_CONFIG_HOME=~/.config
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# sources
source <(kubectl completion zsh)

eval "$(zoxide init zsh)"
eval "$(gh completion -s zsh)"

eval "$(starship init zsh)"

INSTALLATION_PATH=$(brew --prefix switch) && source $INSTALLATION_PATH/switch.sh

# Hishtory Config:
export PATH="$PATH:/Users/erkikal/.hishtory"
source /Users/erkikal/.hishtory/config.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
