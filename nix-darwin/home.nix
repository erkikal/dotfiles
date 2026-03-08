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
    "starship".source = "${config.home.homeDirectory}/github/dotfiles/starship";
    "zellij".source = "${config.home.homeDirectory}/github/dotfiles/zellij";
    "borders".source = "${config.home.homeDirectory}/github/dotfiles/borders";
    # "carapace".source = "${config.home.homeDirectory}/github/dotfiles/carapace";
    "fastfetch".source = "${config.home.homeDirectory}/github/dotfiles/fastfetch";
  xdg = {
    configFile = {
      # "wezterm".source = "${config.home.homeDirectory}/github/dotfiles/wezterm";
      "ghostty".source = "${config.home.homeDirectory}/github/dotfiles/ghostty";
      "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/neovim/erki-kickstart";
      "nix".source = "${config.home.homeDirectory}/github/dotfiles/nix";
      "nix-darwin".source = "${config.home.homeDirectory}/github/dotfiles/nix-darwin";
      "home-manager/home.nix".source = "${config.home.homeDirectory}/github/dotfiles/nix-darwin/home.nix";
      "kanata".source = "${config.home.homeDirectory}/github/dotfiles/kanata";
      "k9s/skins".source = "${config.home.homeDirectory}/github/dotfiles/k9s/skins";
      "raycast".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/raycast";
      "sketchybar".source = "${config.home.homeDirectory}/github/dotfiles/sketchybar";
    };
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

  programs = {
    home-manager.enable = true;
    zsh = {
        fi
        rm -f -- "$tmp"
      }
        fi





      # Add app compatibilities
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
      siteFunctions = 
        {
          # mkdir and cd into it
          "mkcd" = ''
            mkdir -p -- "$1" && cd -P -- "$1"
          '';

          # Set AWS_PROFILE environment variable
          "aws-profile" = ''
            aws-profile() {
              compdef _aws_profile aws-profile

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
          '';

          "_aws_profiles" = ''
            _aws_profiles() {
              if [ -f $HOME/.aws/config ]; then
                local -a profiles
                profiles=($(aws configure list-profiles))
                _describe 'aws profiles' profiles
              fi
            }
          '';

          # Define completion for aws-profile
          "_aws_profile" = ''
            _aws_profile() {
              _arguments '1: :_aws_profiles'
            }
          '';
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        secrets_filter = true;
        enter_accept = true;
      };
    };

    bat = {
      enable = true;
      config = {
        theme = "catppuccin";
      };
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
          };
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "Catppuccin";
        theme_background = true;
        vim_keys = true;
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
      themes = {
        Catppuccin = ''
          # Main background, empty for terminal default, need to be empty if you want transparent background
          theme[main_bg]="#1e1e2e"

          # Main text color
          theme[main_fg]="#cdd6f4"

          # Title color for boxes
          theme[title]="#cdd6f4"

          # Highlight color for keyboard shortcuts
          theme[hi_fg]="#89b4fa"

          # Background color of selected item in processes box
          theme[selected_bg]="#45475a"

          # Foreground color of selected item in processes box
          theme[selected_fg]="#89b4fa"

          # Color of inactive/disabled text
          theme[inactive_fg]="#7f849c"

          # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
          theme[graph_text]="#f5e0dc"

          # Background color of the percentage meters
          theme[meter_bg]="#45475a"

          # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
          theme[proc_misc]="#f5e0dc"

          # CPU, Memory, Network, Proc box outline colors
          theme[cpu_box]="#cba6f7" #Mauve
          theme[mem_box]="#a6e3a1" #Green
          theme[net_box]="#eba0ac" #Maroon
          theme[proc_box]="#89b4fa" #Blue

          # Box divider line and small boxes line color
          theme[div_line]="#6c7086"

          # Temperature graph color (Green -> Yellow -> Red)
          theme[temp_start]="#a6e3a1"
          theme[temp_mid]="#f9e2af"
          theme[temp_end]="#f38ba8"

          # CPU graph colors (Teal -> Lavender)
          theme[cpu_start]="#94e2d5"
          theme[cpu_mid]="#74c7ec"
          theme[cpu_end]="#b4befe"

          # Mem/Disk free meter (Mauve -> Lavender -> Blue)
          theme[free_start]="#cba6f7"
          theme[free_mid]="#b4befe"
          theme[free_end]="#89b4fa"

          # Mem/Disk cached meter (Sapphire -> Lavender)
          theme[cached_start]="#74c7ec"
          theme[cached_mid]="#89b4fa"
          theme[cached_end]="#b4befe"

          # Mem/Disk available meter (Peach -> Red)
          theme[available_start]="#fab387"
          theme[available_mid]="#eba0ac"
          theme[available_end]="#f38ba8"

          # Mem/Disk used meter (Green -> Sky)
          theme[used_start]="#a6e3a1"
          theme[used_mid]="#94e2d5"
          theme[used_end]="#89dceb"

          # Download graph colors (Peach -> Red)
          theme[download_start]="#fab387"
          theme[download_mid]="#eba0ac"
          theme[download_end]="#f38ba8"

          # Upload graph colors (Green -> Sky)
          theme[upload_start]="#a6e3a1"
          theme[upload_mid]="#94e2d5"
          theme[upload_end]="#89dceb"

          # Process box color gradient for threads, mem and cpu usage (Sapphire -> Mauve)
          theme[process_start]="#74c7ec"
          theme[process_mid]="#b4befe"
          theme[process_end]="#cba6f7"
        '';
      };
    };
    gh.enable = true;

    # Uncomment on fresh setups and use Nix to install Ghostty
    # ghostty = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   settings = {
    #     macos-auto-secure-input = true;
    #
    #     clipboard-read = true;
    #     clipboard-write = true;
    #     theme = "Catppuccin Mocha";
    #     background = "#1e1e2e";
    #     foreground = "#cdd6f4";
    #     selection-background = "#585b70";
    #     selection-foreground = "#cdd6f4";
    #     cursor-color = "#f5e0dc";
    #
    #     font-family = "Terminess Nerd Font";
    #     font-size = 14;
    #
    #     macos-option-as-alt = true;
    #     keybind = [
    #       "global:cmd+s=toggle_quick_terminal"
    #       "alt+left=unbind"
    #       "alt+right=unbind"
    #       "alt+two=text:@"
    #       "alt+three=text:£"
    #       "alt+four=text:$"
    #       "alt+seven=text:{"
    #       "alt+eight=text:["
    #       "alt+nine=text:]"
    #       "alt+zero=text:}"
    #       "alt+ä=text:^"
    #       "alt+plus=text:\\"
    #       "alt+<=text:|"
    #     ];
    #
    #     quick-terminal-animation-duration = 0;
    #   };
    # };
    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yy";
      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_sensitive = false;
          sort_dir_first = true;
          show_symlink = true;
        };
        theme = "catppuccin-mocha";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
