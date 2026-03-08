# source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

[[ -f $(brew --prefix switch)/switch.sh ]]; INSTALLATION_PATH=$(brew --prefix switch) && source $INSTALLATION_PATH/switch.sh

autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

complete -C '/usr/local/bin/aws_completer' aws

fastfetch -c examples/8

# Ignore space lines in history
setopt hist_ignore_space

# aliases
source ~/.aliases 
source ~/.zsh/git/git.plugin.zsh
source ~/.zsh/kubectl/kubectl.plugin.zsh

# keybinding
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^[[3~" delete-char

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

# Yazi shell wrapper
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Set AWS_PROFILE environment variable
function aws-profile() {
    if [ -f $HOME/.aws/config ]; then
        if [ -z "$1" ]; then
            if [ -z "$AWS_PROFILE" ]; then
                echo "No AWS profile is currently selected."
            else
                echo "Currently selected AWS profile is $AWS_PROFILE"
            fi
        else
            local profiles=$(aws configure list-profiles)
            local profile=$(echo "$profiles" | grep -w "$1")
            if [[ -n $profile ]]; then
                echo "Setting AWS_PROFILE to $1"
                export AWS_PROFILE=$1
            else
                echo "Profile $1 not found in $HOME/.aws/config"
            fi
        fi
    else
        echo "404: $HOME/.aws/config not found."
    fi
}

# Autocomplete for aws-profile
if type aws-profile &>/dev/null; then
    # Get AWS profiles for completion
    function _aws_profiles() {
        if [ -f $HOME/.aws/config ]; then
            local -a profiles
            profiles=($(aws configure list-profiles))
            _describe 'aws profiles' profiles
        fi
    }
    
    # Define completion for aws-profile
    function _aws_profile() {
        _arguments '1: :_aws_profiles'
    }
    
    # Register completion for aws-profile
    compdef _aws_profile aws-profile
fi

# mkdir and cd into it
mkcd ()
{
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# exports
# export XDG_CONFIG_HOME=~/.config
# export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
# export ZSH_CACHE_DIR=~/github/.dotfiles/zsh/plugins/zsh-completions/src
#
# export EDITOR=nvim
# export VISUAL=nvim
# export LANG=en_US.UTF-8
#
# export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
# export LS_COLORS=$(vivid generate catppuccin-mocha)
#
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
#
# # Set AWS_DEFAULT_REGION environment variable. This will set default region for all AWS CLI commands.
# export AWS_DEFAULT_REGION=eu-north-1
#
# path=($HOME/.rd/bin $path)

# sources
eval "$(zoxide init zsh)"
eval "$(gh completion -s zsh)"
eval "$(atuin init zsh)"
source <(carapace _carapace zsh)

eval "$(starship init zsh)"
