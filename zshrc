source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

[[ -f $(brew --prefix switch)/switch.sh ]]; INSTALLATION_PATH=$(brew --prefix switch) && source $INSTALLATION_PATH/switch.sh

autoload -Uz compinit
compinit

# aliases
source ~/.aliases 
source ~/.zsh/git/git.plugin.zsh
source ~/.zsh/kubectl/kubectl.plugin.zsh

# keybinding
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# functions
# Add privileges app request to sudo
#function sudo() {
#    local sudo_status=$(privilegescli --status 2>&1)
#
#    if [[ $sudo_status == *"User $USER has standard user rights"* ]]; then
#        privilegescli --add
#    fi
#
#    command sudo "$@"
#}

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
export ZSH_CACHE_DIR=~/github/.dotfiles/zsh/plugins/zsh-completions/src

export EDITOR=nvim
export VISUAL=nvim
export LANG=en_US.UTF-8

# sources
eval "$(zoxide init zsh)"
eval "$(gh completion -s zsh)"

eval "$(starship init zsh)"
