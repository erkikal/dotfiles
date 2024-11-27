# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "erkikal";
  home.homeDirectory = "/Users/erkikal";
  home.stateVersion = "24.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
    pkgs.atuin
    pkgs.docker
  ];

  # Home Manager is pretty good at managing github/dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = ~/github/dotfiles/zshrc;
    ".aliases".source = ~/github/dotfiles/aliases/aliases;
  };
  xdg.configFile = {
    "wezterm".source = ~/github/dotfiles/wezterm;
    "starship".source = ~/github/dotfiles/starship;
    "zellij".source = ~/github/dotfiles/zellij;
    "nvim".source = ~/github/dotfiles/neovim/erki-kickstart;
    "nix".source = ~/github/dotfiles/nix;
    "nix-darwin".source = ~/github/dotfiles/nix-darwin;
    "home-manager/home.nix".source = ~/github/dotfiles/nix-darwin/home.nix;
    "bat".source = ~/github/dotfiles/bat;
    "borders".source = ~/github/dotfiles/borders;
    "btop".source = ~/github/dotfiles/btop;
    "fastfetch".source = ~/github/dotfiles/fastfetch;
    "k9s".source = ~/github/dotfiles/k9s;
    "sketchybar".source = ~/github/dotfiles/sketchybar;
    "yazi".source = ~/github/dotfiles/yazi;
    "zsh".source = ~/github/dotfiles/zsh;
    # "tmux".source = ~/github/dotfiles/tmux;

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
