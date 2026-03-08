# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "erkik";
  home.homeDirectory = "/Users/erkik";
  home.stateVersion = "25.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    pkgs.atuin
    pkgs.rancher
    pkgs.vault
  ];

  # Home Manager is pretty good at managing github/dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = "${config.home.homeDirectory}/github/dotfiles/zshrc";
    ".aliases".source = "${config.home.homeDirectory}/github/dotfiles/aliases/aliases";
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
    "yazi".source = "${config.home.homeDirectory}/github/dotfiles/yazi";
    # "tmux".source = "${config.home.homeDirectory}/github/dotfiles/tmux";

  };

  home.sessionVariables = {
    AWS_DEFAULT_REGION = "eu-north-1";
    XDG_CONFIG_HOME = "$HOME/.config";

    STARSHIP_CONFIG = "$HOME/.config/starship/starship.toml";
    ZSH_CACHE_DIR = "$HOME/github/dotfiles/zsh/plugins/zsh-completions/src";

    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";

    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense"; # optional
    LS_COLORS = "$(vivid generate catppuccin-mocha)";

    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.rd/bin"
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
    '';
  };
}
