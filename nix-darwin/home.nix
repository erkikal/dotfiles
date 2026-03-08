# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "erkik";
  home.homeDirectory = "/Users/erkik";
  home.stateVersion = "25.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = with pkgs; [
    atuin
    # rancher
    vault
  ];

  # Home Manager is pretty good at managing github/dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zsh".source = "${config.home.homeDirectory}/github/dotfiles/zsh";
  };
  xdg.configFile = {
    # "wezterm".source = "${config.home.homeDirectory}/github/dotfiles/wezterm";
    "ghostty".source = "${config.home.homeDirectory}/github/dotfiles/ghostty";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/neovim/erki-kickstart";
    "nix".source = "${config.home.homeDirectory}/github/dotfiles/nix";
    "nix-darwin".source = "${config.home.homeDirectory}/github/dotfiles/nix-darwin";
    "home-manager/home.nix".source = "${config.home.homeDirectory}/github/dotfiles/nix-darwin/home.nix";
    "starship".source = "${config.home.homeDirectory}/github/dotfiles/starship";
    "zellij".source = "${config.home.homeDirectory}/github/dotfiles/zellij";
    "atuin".source = "${config.home.homeDirectory}/github/dotfiles/atuin";
    "bat".source = "${config.home.homeDirectory}/github/dotfiles/bat";
    "borders".source = "${config.home.homeDirectory}/github/dotfiles/borders";
    "btop".source = "${config.home.homeDirectory}/github/dotfiles/btop";
    # "carapace".source = "${config.home.homeDirectory}/github/dotfiles/carapace";
    "fastfetch".source = "${config.home.homeDirectory}/github/dotfiles/fastfetch";
    "kanata".source = "${config.home.homeDirectory}/github/dotfiles/kanata";
    # "k9s".source = "${config.home.homeDirectory}/github/dotfiles/k9s";
    "raycast".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/raycast";
    "sketchybar".source = "${config.home.homeDirectory}/github/dotfiles/sketchybar";
    "yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/yazi";
    # "tmux".source = "${config.home.homeDirectory}/github/dotfiles/tmux";

  };

  home.sessionVariables = {
    AWS_DEFAULT_REGION = "eu-north-1";
    XDG_CONFIG_HOME = "$HOME/.config";

    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";

    LS_COLORS = "$(vivid generate catppuccin-mocha)";

    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";

    ZELLIJ_SESSION_NAME = "Main";

    WORDCHARS = "*?.[]~=&;!#$%^(){}<>";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.rd/bin"
    "$HOME/.local/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initContent = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      [[ -f $(brew --prefix switch)/switch.sh ]]; INSTALLATION_PATH=$(brew --prefix switch) && source $INSTALLATION_PATH/switch.sh

      fastfetch -c examples/8

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

      # Get local network interfaces IP addresses
      function ip-addr (){
        for i in $(ifconfig -lu)
        do
          if ifconfig $i | grep -q "inet "
          then
            ifconfig $i
          fi
        done
      }

      # Add app compatibilities
      eval "$(zoxide init zsh)"
      eval "$(gh completion -s zsh)"
      eval "$(atuin init zsh)"
      source <(carapace _carapace zsh)

      eval "$(starship init zsh)"
    '';
    autosuggestion.enable = true;
    shellAliases = 
      {
        reload = "source ~/.zshrc";
        hist = "history 1 | less";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        ybssh = "ssh-add -s /usr/local/lib/libykcs11.dylib";

        # Indent clipboard with space, so if pasted to shell (bash/zsh), it doesn't get saved in history file
        repaste = "pbpaste | sed -e \"s/^/ /\" | pbcopy";
      };
    shellGlobalAliases =
      {
        l = "eza -lafF --color=auto --icons=auto";
        ll = "eza -laF --group-directories-first --color=auto";
        lt = "eza --tree --level=2 --long --icons --git";
        v = "nvim";
        vim = "nvim";
        cat = "bat";
        lg = "lazygit";

        # confirm before overwriting something
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";

        # easier to read disk
        df = "df -h";     # human-readable sizes
        free = "free -m"; # show sizes in MB

        # Improve common commands
        mkdir = "mkdir -p";
      };
  };
}
