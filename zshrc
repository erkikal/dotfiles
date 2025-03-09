# source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
export XDG_CONFIG_HOME=~/.config
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ZSH_CACHE_DIR=~/github/.dotfiles/zsh/plugins/zsh-completions/src

export EDITOR=nvim
export VISUAL=nvim
export LANG=en_US.UTF-8

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
export LS_COLORS=$(vivid generate catppuccin-mocha)

# sources
eval "$(zoxide init zsh)"
eval "$(gh completion -s zsh)"
eval "$(atuin init zsh)"
source <(carapace _carapace zsh)

eval "$(starship init zsh)"
