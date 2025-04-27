# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "erkikal";
  home.homeDirectory = "/Users/erkikal";
  home.stateVersion = "25.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    pkgs.atuin
    pkgs.docker
  ];

  # Home Manager is pretty good at managing github/dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = "${config.home.homeDirectory}/github/dotfiles/zshrc";
    ".aliases".source = "${config.home.homeDirectory}/github/dotfiles/aliases/aliases";
  };
  xdg.configFile = {
    "wezterm".source = "${config.home.homeDirectory}/github/dotfiles/wezterm";
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
    "carapace".source = "${config.home.homeDirectory}/github/dotfiles/carapace";
    "fastfetch".source = "${config.home.homeDirectory}/github/dotfiles/fastfetch";
    "kanata".source = "${config.home.homeDirectory}/github/dotfiles/kanata";
    "k9s".source = "${config.home.homeDirectory}/github/dotfiles/k9s";
    "raycast".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/github/dotfiles/raycast";
    "sketchybar".source = "${config.home.homeDirectory}/github/dotfiles/sketchybar";
    "yazi".source = "${config.home.homeDirectory}/github/dotfiles/yazi";
    "zsh".source = "${config.home.homeDirectory}/github/dotfiles/zsh";
    # "tmux".source = "${config.home.homeDirectory}/github/dotfiles/tmux";

  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
